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
#import "NSDecimalNumber+SquareRoot.h"

@interface MyCalculatorViewController ()
@property (nonatomic) BOOL userIsEnteringANumber;
@property (nonatomic) BOOL hasEnteredDot;
@property (nonatomic) BOOL displayNeedsClearingPrior;

@property (strong, nonatomic) IBOutlet UILabel *lblDisplay;
@property (strong, nonatomic) IBOutlet UILabel *lblOperatorDisplay;

@end

@implementation MyCalculatorViewController

@synthesize lblDisplay;
@synthesize engine;

const int MAX_DISPLAY_LENGTH = 12;

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
    
    [self checkForErrorScreen];
    
    NSString *digit = sender.currentTitle;
    
    // If the user is entering a number, append the digit (max 12 chars)
    if (self.userIsEnteringANumber) {
        if ([self.lblDisplay.text length] <= MAX_DISPLAY_LENGTH && ( ! [sender.currentTitle isEqualToString:@"."] || ! self.hasEnteredDot)) {
            self.lblDisplay.text = [self.lblDisplay.text stringByAppendingString:digit];
        }
    // Otherwise just set the display to the digit
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
    [self checkForErrorScreen];
    
    [self pushOperand];
    
    // Add the operator to the infix stack
    [self.engine.infixStack addObject:[self realOperator:sender.currentTitle]];
    self.lblOperatorDisplay.text = sender.currentTitle;
    
    self.userIsEnteringANumber = NO;
}

// Map the unicode operators (used for display) to traditional operators
- (NSString *)realOperator:(NSString *)displayOperator
{
    NSDictionary *operators = @{
                                @"%": @"%",
                                @"√": @"sqrt",
                                @"÷": @"/",
                                @"×": @"*",
                                @"-": @"-",
                                @"+": @"+",
                                @"±": @"flip"
                                };
    
    return [operators objectForKey:displayOperator];
}

- (void)pushOperand
{
    // Convert the display to an NSDecimalNumber and push to the infix stack
    [self.engine.infixStack addObject:[NSDecimalNumber numberWithDouble:[self.lblDisplay.text doubleValue]]];
    
    // User is no longer entering a number and has not entered a dot (next digit pressed is part
    // of a new number)
    self.userIsEnteringANumber = NO;
    self.hasEnteredDot         = NO;
}

- (IBAction)calculate:(id)sender
{
    [self checkForErrorScreen];
    
    // Push the last operand that was entered
    [self pushOperand];
    
    self.lblOperatorDisplay.text = @"=";
    
    @try {
        // Get the result from the calculator engine
        NSDecimalNumber *result = [self.engine calculate];
        
        // Display the result as a formatted number
        self.lblDisplay.text = [MyCalculatorViewController formatNumber:result];
        
        NSLog(@"Result: %@", result);
    }
    @catch (NSException *exception) {
        // Catch any calculator errors (such as division by zero)
        self.lblDisplay.text = @"ERROR";
        self.displayNeedsClearingPrior = YES;
        
    }

    self.userIsEnteringANumber = NO;
}

+ (NSString *)formatNumber:(NSDecimalNumber *)number
{
    // Format the number to decimal style with a max display length
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    // Try to format the number in a display friendly manner
    if ([number compare:@10000000000] == NSOrderedDescending) {
        [formatter setNumberStyle:NSNumberFormatterScientificStyle];
    } else {
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    
    [formatter setMaximumFractionDigits:MAX_DISPLAY_LENGTH];
    [formatter setMaximumIntegerDigits:MAX_DISPLAY_LENGTH];
    [formatter setGroupingSeparator:@""];
    return [formatter stringFromNumber:number];
}

// Perform a unary operator
- (IBAction)performImmediateOperation:(UIButton *)sender {
    
    [self checkForErrorScreen];
    
    NSString *operator = [self realOperator:sender.currentTitle];
    NSDecimalNumber *currentNumber = [NSDecimalNumber decimalNumberWithString:self.lblDisplay.text];
    
    // Perform the operation on the number
    if ([operator isEqualToString:@"%"]) {
        currentNumber = [currentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    } else if ([operator isEqualToString:@"sqrt"]) {
        currentNumber = [currentNumber squareRoot];
    } else if ([operator isEqualToString:@"flip"]) {
        currentNumber = [currentNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
    }
    
    self.lblDisplay.text = [MyCalculatorViewController formatNumber:currentNumber];
    
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
    self.lblOperatorDisplay.text = @"";
    self.userIsEnteringANumber = NO;
    self.hasEnteredDot = NO;
}

- (void)checkForErrorScreen
{
    // Recover after an error screen
    if (self.displayNeedsClearingPrior) {
        [self clearPressed];
        self.displayNeedsClearingPrior = NO;
    }
}

@end
