//
//  MyCalculatorViewController.m
//  MyCalculator
//
//  Created by Austin White on 3/5/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import "MyCalculatorViewController.h"
#import "ShuntingYard.h"
#import "CalculatorEngine.h"

@interface MyCalculatorViewController ()
@property (nonatomic) BOOL userIsEnteringANumber;
@property (nonatomic) BOOL hasEnteredDot;

@property (strong, nonatomic) IBOutlet UILabel *lblDisplay;
@property (strong, nonatomic) IBOutlet UILabel *lblOperatorDisplay;

@end

@implementation MyCalculatorViewController

@synthesize lblDisplay;
@synthesize engine;

- (CalculatorEngine *)engine
{
    if (engine == nil) {
        engine = [[CalculatorEngine alloc] init];
    }
    
    return engine;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Change status bar to white color
    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark Calculator Buttons
- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    if (self.userIsEnteringANumber) {
        if ( ! [sender.currentTitle isEqualToString:@"."] || ! self.hasEnteredDot) {
            self.lblDisplay.text = [self.lblDisplay.text stringByAppendingString:digit];
        }
    } else {
        self.lblDisplay.text = digit;
        self.userIsEnteringANumber = YES;
    }
    
    if ([sender.currentTitle isEqualToString:@"."]) {
        self.hasEnteredDot = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    [self pushOperand];
    
    [self.engine.infixStack addObject:[self realOperator:sender.currentTitle]];
    self.lblOperatorDisplay.text = sender.currentTitle;
}

- (NSString *)realOperator:(NSString *)displayOperator
{
    NSArray *operators = @[@"%", @"√", @"÷", @"×", @"-", @"+", @"±"],
            *realOperators = @[@"%", @"sqrt", @"/", @"*", @"-", @"+", @"flip"];
    
    return [realOperators objectAtIndex:[operators indexOfObject:displayOperator]];
}

- (void)pushOperand
{
    if (self.userIsEnteringANumber) {
        [self.engine.infixStack addObject:[NSDecimalNumber numberWithDouble:[self.lblDisplay.text doubleValue]]];
        self.userIsEnteringANumber = NO;
    }
    
    self.hasEnteredDot = NO;
}
- (IBAction)calculate:(id)sender {
    
    [self pushOperand];
    
    self.lblOperatorDisplay.text = @"=";
    
    NSDecimalNumber *result = [self.engine calculate];
    
    self.lblDisplay.text = [result stringValue];
    
    NSLog(@"Result: %@", result);
    
    self.userIsEnteringANumber = NO;
}
- (IBAction)performImmediateOperation:(UIButton *)sender {
    NSString *operator = [self realOperator:sender.currentTitle];
    NSDecimalNumber *currentNumber = [NSDecimalNumber decimalNumberWithString:self.lblDisplay.text];
    
    if ([operator isEqualToString:@"%"]) {
        currentNumber = [currentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    } else if ([operator isEqualToString:@"sqrt"]) {
        currentNumber = [currentNumber decimalNumberByRaisingToPower:@0];
    } else if ([operator isEqualToString:@"flip"]) {
        currentNumber = [currentNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
    }
    
    self.lblDisplay.text = [currentNumber stringValue];
    
    // If the user is not entering a number, need to modify the value on the stack
    if ( ! self.userIsEnteringANumber) {
        [self.engine clearStack];
        [self.engine.infixStack addObject:currentNumber];
    }
}

- (IBAction)clearPressed
{
    [self.engine clearStack];
    self.lblDisplay.text = @"0";
    self.userIsEnteringANumber = NO;
    self.hasEnteredDot = NO;
}

@end
