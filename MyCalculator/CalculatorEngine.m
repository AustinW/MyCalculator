//
//  CalculatorEngine.m
//  MyCalculator
//
//  Created by Austin White on 3/5/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import "CalculatorEngine.h"

static CalculatorEngine *_mainEngine;

@implementation CalculatorEngine

+ (CalculatorEngine *) mainEngine
{
	if (_mainEngine == nil) {
		_mainEngine = [[CalculatorEngine alloc] init];
	}
    
	return _mainEngine;
}

@end

