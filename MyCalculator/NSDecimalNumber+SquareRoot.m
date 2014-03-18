//
//  NSDecimalNumber+SquareRoot.m
//  CubeRoot
//
//  Created by Michael Taylor on 10-06-21.
//

#import "NSDecimalNumber+SquareRoot.h"

static NSString * Tolerance = @"0.0000000000000001";

static NSDecimalNumber * MinusOne = nil;

@implementation NSDecimalNumber (SquareRoot)

- (NSDecimalNumber *) squareRoot
{
    NSComparisonResult comparison = [self compare:[NSDecimalNumber zero]];
    if (comparison == NSOrderedAscending)
        return [NSDecimalNumber notANumber];
    else if (comparison == NSOrderedSame)
	return [NSDecimalNumber zero];
    
    NSDecimalNumber *half =
    [[NSDecimalNumber one] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"2"]];
    NSDecimalNumber *guess =
    [[self decimalNumberByAdding:[NSDecimalNumber one]]
     decimalNumberByMultiplyingBy:half];
    NSDecimalNumber * next_guess;
    
    @try
    {
        while (TRUE)
        {
	    next_guess = [[[self decimalNumberByDividingBy:guess]
			   decimalNumberByAdding:guess]
			  decimalNumberByMultiplyingBy:half];
	    
	    if ([next_guess isEquivalentTo:guess])
		// We are close enough
		break;
	    
	    guess = next_guess;
        }
    }
    @catch (NSException *exception)
    {
        // deliberately ignore exception and assume the last guess is good enough
    }
    
    NSDecimalNumber * int_value = (NSDecimalNumber*)[NSDecimalNumber numberWithInt:[guess intValue]];
    if ([guess isEquivalentTo:int_value])
	return int_value;
    else
	return guess;
}

- (NSDecimalNumber *) cubeRoot
{
    NSComparisonResult comparison = [self compare:[NSDecimalNumber zero]];
    if (comparison == NSOrderedSame)
	return [NSDecimalNumber zero];
    
    BOOL negative = NO;
    NSDecimalNumber * value = [self abs];
    NSDecimalNumber * guess, * next_guess, * two, * three;
    
    if ([self compare:[NSDecimalNumber zero]] == NSOrderedAscending)
    {
        negative = YES;
	value = [self abs];
    }
    
    guess = [self sign];
    two = [NSDecimalNumber decimalNumberWithString:@"2"];
    three = [NSDecimalNumber decimalNumberWithString:@"3"];
    
    @try
    {
        while (TRUE)
        {
	    // (x/y^2 + 2y)/3
	    next_guess = [[[self decimalNumberByDividingBy:
			    [guess decimalNumberByMultiplyingBy:guess]] 
			   decimalNumberByAdding:
			   [two decimalNumberByMultiplyingBy:guess]] 
			  decimalNumberByDividingBy:three];
	    
	    if ([next_guess isEquivalentTo:guess])
		// We are close enough
		break;
		
	    guess = next_guess;
        }
    }
    @catch (NSException *exception)
    {
        // deliberately ignore exception and assume the last guess is good enough
    }
    
    NSDecimalNumber * int_value = (NSDecimalNumber*)[NSDecimalNumber numberWithInt:[guess intValue]];
    if ([guess isEquivalentTo:int_value])
	return int_value;
    else
	return guess;
}

// Absolute value
- (NSDecimalNumber *) abs
{
    if (!MinusOne)
	MinusOne = [NSDecimalNumber decimalNumberWithString:@"-1"];
    
    if ([self compare:[NSDecimalNumber zero]] == NSOrderedAscending)
	return [self decimalNumberByMultiplyingBy:MinusOne];
    else
	return self;
}
		 
// Sign returns either 1.0 or -1.0 depending on the sign of the value
- (NSDecimalNumber *) sign
{
    if (!MinusOne)
	MinusOne = [NSDecimalNumber decimalNumberWithString:@"-1"];
    
    if ([self compare:[NSDecimalNumber zero]] == NSOrderedAscending)
	return MinusOne;
    else
	return [NSDecimalNumber one];
}

// Equivalence test
- (BOOL) isEquivalentTo:(NSDecimalNumber*)number
{
    static NSDecimalNumber * tolerance = nil;
    
    if (!tolerance)
	tolerance = [NSDecimalNumber decimalNumberWithString:Tolerance];
    
    NSDecimalNumber * difference = [[self decimalNumberBySubtracting:number] abs];    
    return [difference compare:tolerance] == NSOrderedAscending;
}

@end
