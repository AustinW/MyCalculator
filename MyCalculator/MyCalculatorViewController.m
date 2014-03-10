//
//  MyCalculatorViewController.m
//  MyCalculator
//
//  Created by Austin White on 3/5/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import "MyCalculatorViewController.h"
#import "ShuntingYard.h"

@interface MyCalculatorViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblDisplay;

@end

@implementation MyCalculatorViewController

@synthesize lblDisplay;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Change status bar to white color
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    // Testing...
    NSDictionary *tokens = @{
                             @"+": @{@"precedence": @0, @"associativity": @"left"},
                             @"-": @{@"precedence": @0, @"associativity": @"left"},
                             @"*": @{@"precedence": @1, @"associativity": @"left"},
                             @"/": @{@"precedence": @1, @"associativity": @"left"},
                             @"%": @{@"precedence": @1, @"associativity": @"left"},
    };
    
    ShuntingYard *shuntingYard = [[ShuntingYard alloc] initWithOperators:tokens];
    NSLog(@"%@", [shuntingYard shuntingYardWithTokens:@[@"1", @"+", @"2", @"*", @"3"]]);
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark Calculations
- (void)push:(NSString *)item onTopOfStack:(NSMutableArray *)stack
{
    
}

- (NSString *)pop:(NSMutableArray *)stack
{
    return @"";
}

#pragma mark Calculator Buttons
- (IBAction)calculatorButtonPressed:(UIButton *)sender {
    
    NSArray *operators = @[@"%", @"√", @"÷", @"×", @"-", @"+", @"±"],
            *operands  = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"."];
    
    if ([operators containsObject:[sender currentTitle]]) {
        NSLog(@"Button is an operator: %@", [sender currentTitle]);
    } else if ([operands containsObject:[sender currentTitle]]) {
        NSLog(@"Button is an operand: %@", [sender currentTitle]);
    } else if ([[sender currentTitle] isEqualToString:@"AC"]) {
        NSLog(@"Clearing screen...");
    } else if ([[sender currentTitle] isEqualToString:@"="]) {
        NSLog(@"Calculating...");
    }
}



@end
