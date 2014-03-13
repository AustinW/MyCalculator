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
    
    
    self.displayStatus = ENTERED;
    
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
    
    NSDecimalNumber *result = [self.engine calculate];
    self.lblDisplay.text = [NSString stringWithFormat:@"%g", [result doubleValue]];
}

- (NSString *)realOperator:(NSString *)displayOperator
{
    NSArray *operators = @[@"%", @"√", @"÷", @"×", @"-", @"+", @"±"],
            *realOperators = @[@"%", @"sqrt", @"/", @"*", @"-", @"+", @"flip"];
    
    return [realOperators objectAtIndex:[operators indexOfObject:displayOperator]];
}

- (IBAction)calculatorButtonPressed:(UIButton *)sender {
    
//    NSArray *operators = @[@"%", @"√", @"÷", @"×", @"-", @"+", @"±"],
//            *realOperators = @[@"%", @"sqrt", @"/", @"*", @"-", @"+", @"flip"],
//            *operands  = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"."];
//    
//    if ([operators containsObject:[sender currentTitle]]) {
//        [self.infixStack addObject:[self.lblDisplay text]];
//        [self.infixStack addObject: [realOperators objectAtIndex:[operators indexOfObject:[sender currentTitle]]]];
//        
//        [self setDisplayStatus:ENTERING_OPERATORS];
//        [self updateDisplayWith:[sender currentTitle]];
//        
//    } else if ([operands containsObject:[sender currentTitle]]) {
//        
//        [self updateDisplayWith:[sender currentTitle]];
//        self.displayStatus = ENTERING_NUMBERS;
//        
//    } else if ([[sender currentTitle] isEqualToString:@"AC"]) {
//        
//        
//    } else if ([[sender currentTitle] isEqualToString:@"="]) {
//        
//        [self.infixStack addObject:[self.lblDisplay text]];
//        
//        NSLog(@"infix stack: %@", self.infixStack);
//        NSArray *postfix = [self.infixToPostfix shuntingYardWithTokens:self.infixStack];
//        NSLog(@"Calculating...");
//        NSLog(@"Postfix stack: %@", postfix);
//        
//    }
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
    NSDecimalNumber *result = [self.engine calculate];
    NSLog(@"Result: %@", result);
}

- (IBAction)clearPressed
{
    [self.engine clearStack];
    self.lblDisplay.text = @"0";
    self.userIsEnteringANumber = NO;
    self.hasEnteredDot = NO;
}



@end
