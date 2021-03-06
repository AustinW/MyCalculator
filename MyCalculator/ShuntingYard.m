//
//  ShuntingYard.m
//  MyCalculator
//
//  Created by Austin White on 3/9/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//
//  References: https://igor.io/2013/12/03/stack-machines-shunting-yard.html
//  Followed article by Igor Wiedler revealing a shunting yard algorithm
//  implementation written in PHP and adapted for Objective-C making use of
//  a stack (by Matt Galloway) and a queue (NSMutableArray category methods)
//

#import "ShuntingYard.h"
#import "MJGStack.h"
#import "NSMutableArray+QueueAdditions.h"

@implementation ShuntingYard

@synthesize stack = _stack, output = _output, operators = _operators;

- (id) initWithOperators:(NSDictionary *)operators
{
    self = [self init];
    
    if (self != nil) {
        self.stack = nil;
        self.output = nil;
        self.operators = operators;
    }
    
    return self;
}

- (MJGStack *)stack
{
    if ( ! _stack) {
        _stack = [[MJGStack alloc] init];
    }
    
    return _stack;
}

- (NSMutableArray *)output
{
    if ( ! _output) {
        _output = [[NSMutableArray alloc] init];
    }
    
    return _output;
}

- (NSArray *)shuntingYardWithTokens:(NSArray *)tokens
{
    
    for (NSString *token in tokens) {
        
        if ([token isKindOfClass:[NSDecimalNumber class]] || ([token isKindOfClass:[NSString class]] && [ShuntingYard stringIsNumeric:token])) {
            
            // Push the token into the output queue if it is of type NSDecimalNumber or a numeric string
            [self.output enqueue:token];
        
        // If the token is an operator
        } else if ([self.operators objectForKey:token]) {
            
            NSString *o1 = token;
            NSString *o2 = [self.stack peekObject];
            
            // If the top of the stack has an operator and o1 has lower precedence than o2
            while ([self hasOperator] && [self o1:o1 hasLowerPrecedenceThan:o2]) {
                // Queue the token at the top of the stack
                [self.output enqueue:[self.stack popObject]];
            }
            
            // Push o1 onto the stack
            [self.stack pushObject:o1];
            
        } else if ([token isEqualToString:@"("]) {
        
            [self.stack pushObject:token];
 
        } else if ([token isEqualToString:@")"]) {
            
            while ([self.stack count] > 0 && ! [[self.stack peekObject] isEqualToString:@"("]) {
                
                [self.output enqueue:[self.stack popObject]];
            
            }
            
            if ([self.stack count] == 0) {
                [NSException raise:@"Invalid Argument Exception" format:@"Mismatched parenthesis in input: %@", tokens];
            }
            
            [self.stack popObject];
        } else {
            [NSException raise:@"Invalid Argument Exception" format:@"Invalid token: %@", token];
        }
        
    }
    
    while ([self hasOperator]) {
        
        [self.output enqueue:[self.stack popObject]];
   
    }
    
    if ([self.stack count] > 0) {
        [NSException raise:@"Invalid Argument Exception" format:@"Mismatched parenthesis or misplaced number in input: %@", tokens];
    }
    
    return self.output;
}

- (void) reset
{
    _stack = nil;
    _output = nil;
}

- (BOOL) hasOperator
{
    NSString *top = [self.stack peekObject];
    
    return [self.stack count] > 0 && top && [self.operators objectForKey:top];
}

- (BOOL) o1:(NSString *)o1 hasLowerPrecedenceThan:(NSString *)o2
{
    // Check if o1 has lower precedence than o2. See the instantiation of this object for
    // a visual of the precedence dictionary
    NSDictionary *op1 = [self.operators objectForKey:o1],
    *op2 = [self.operators objectForKey:o2];
    
    int op1Precedence = [[op1 objectForKey:@"precedence"] intValue],
    op2Precedence = [[op2 objectForKey:@"precedence"] intValue];
    
    return (([[op1 objectForKey:@"associativity"] isEqualToString:@"left"] && op1Precedence == op2Precedence) || op1Precedence < op2Precedence);
}

// From: http://stackoverflow.com/a/3474311/410166
+ (BOOL) stringIsNumeric:(NSString *)str {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:str];
    return !!number; // If the string is not numeric, number will be nil
}

@end
