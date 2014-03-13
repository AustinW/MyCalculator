//
//  CalculatorEngine.h
//  MyCalculator
//
//  Created by Austin White on 3/5/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShuntingYard.h"

@interface CalculatorEngine : NSObject

@property (strong, nonatomic) NSMutableArray *infixStack;
@property (strong, nonatomic) ShuntingYard *shuntingYard;

+ (CalculatorEngine *) mainEngine;

- (NSDecimalNumber *)calculate;
- (void)clearStack;

@end