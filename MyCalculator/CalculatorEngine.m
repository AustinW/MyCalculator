//
//  CalculatorEngine.m
//  MyCalculator
//
//  Created by Austin White on 3/5/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import "CalculatorEngine.h"
#import "ShuntingYard.h"
#import "MJGStack.h"

static CalculatorEngine* _mainEngine;

@implementation CalculatorEngine

@synthesize infixToPostfix = _infixToPostfix;
@synthesize infixStack = _infixStack;

+ (CalculatorEngine *) mainEngine
{
	if (_mainEngine == nil) {
		_mainEngine = [[CalculatorEngine alloc] init];
	}
    
	return _mainEngine;
}

- (ShuntingYard *)infixToPostfix
{
    NSDictionary *tokens = @{
                             @"+": @{@"precedence": @0, @"associativity": @"left"},
                             @"-": @{@"precedence": @0, @"associativity": @"left"},
                             @"*": @{@"precedence": @1, @"associativity": @"left"},
                             @"/": @{@"precedence": @1, @"associativity": @"left"},
                             @"%": @{@"precedence": @1, @"associativity": @"left"},
                             };
    
    if ( ! _infixToPostfix) {
        _infixToPostfix = [[ShuntingYard alloc] initWithOperators:tokens];
    }
    
    return _infixToPostfix;
}

- (NSDecimalNumber *)calculate
{
    MJGStack *tempStack = [[MJGStack alloc] init];
    NSArray *tokens = [self.infixToPostfix shuntingYardWithTokens:self.infixStack];
    
    NSLog(@"Tokens: %@", tokens);
    NSDecimalNumber *x, *y;
    
    for (id operation in tokens) {
        
        if ([operation isKindOfClass:[NSDecimalNumber class]]) {
            // Number
            [tempStack pushObject:operation];
            continue;
        }
        
        if ([operation isKindOfClass:[NSString class]]) {
            if ([operation isEqualToString:@"+"]) {
                x = [tempStack popObject];
                y = [tempStack popObject];
                
                [tempStack pushObject:[x decimalNumberByAdding:y]];
            } else if ([operation isEqualToString:@"-"]) {
                x = [tempStack popObject];
                y = [tempStack popObject];
                
                [tempStack pushObject:[x decimalNumberBySubtracting:y]];
            } else if ([operation isEqualToString:@"*"]) {
                x = [tempStack popObject];
                y = [tempStack popObject];
                
                [tempStack pushObject:[x decimalNumberByMultiplyingBy:y]];
            } else if ([operation isEqualToString:@"/"]) {
                x = [tempStack popObject];
                y = [tempStack popObject];
                
                if ([y isEqualToValue:@0])
                    [NSException raise:@"Division by zero" format:@"Cannot divide numbers by zero"];
                else
                    [tempStack pushObject:[x decimalNumberByDividingBy:y]];
            } else {
                [NSException raise:@"Invalid argument exception" format:@"Unrecognized operator"];
            }
        }
    }
    
    return [tempStack peekObject];
}

// From: http://stackoverflow.com/a/3474311/410166
+ (BOOL) stringIsNumeric:(NSString *)str {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:str];
    return !!number; // If the string is not numeric, number will be nil
}

- (void)clearStack
{
    
}

@end

