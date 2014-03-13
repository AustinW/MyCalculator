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

@synthesize shuntingYard = _shuntingYard;
@synthesize infixStack = _infixStack;

+ (CalculatorEngine *) mainEngine
{
	if (_mainEngine == nil) {
		_mainEngine = [[CalculatorEngine alloc] init];
	}
    
	return _mainEngine;
}

- (ShuntingYard *)shuntingYard
{
    NSDictionary *tokens = @{
                             @"+": @{@"precedence": @0, @"associativity": @"left"},
                             @"-": @{@"precedence": @0, @"associativity": @"left"},
                             @"*": @{@"precedence": @1, @"associativity": @"left"},
                             @"/": @{@"precedence": @1, @"associativity": @"left"},
                             @"%": @{@"precedence": @1, @"associativity": @"left"},
                             };
    
    if ( ! _shuntingYard) {
        _shuntingYard = [[ShuntingYard alloc] initWithOperators:tokens];
    }
    
    return _shuntingYard;
}

- (NSMutableArray *)infixStack
{
    if (_infixStack == nil) {
        _infixStack = [[NSMutableArray alloc] init];
    }
    
    return _infixStack;
}

- (NSDecimalNumber *)calculate
{
    MJGStack *tempStack = [[MJGStack alloc] init];
    NSArray *tokens = [self.shuntingYard shuntingYardWithTokens:self.infixStack];
    
    NSLog(@"Infix stack: %@", self.infixStack);
    NSLog(@"Postfix stack: %@", tokens);
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
                
                [tempStack pushObject:[y decimalNumberBySubtracting:x]];
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
    
    // Clear the whole stack
    [self clearStack];
    
    NSDecimalNumber *result = [tempStack popObject];
    
    // Add only the resulting number back to the infix stack
    [self.infixStack addObject:result];
    
    // Return the top of the infix stack (result)
    return result;
}

- (void)clearStack
{
    [self.infixStack removeAllObjects];
    [self.shuntingYard reset];
}

@end

