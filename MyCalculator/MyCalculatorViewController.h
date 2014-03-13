//
//  MyCalculatorViewController.h
//  MyCalculator
//
//  Created by Austin White on 3/5/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorEngine.h"

typedef enum DisplayStatus : NSUInteger {
    ENTERING_NUMBERS,
    ENTERING_OPERATORS,
    ENTERED
} DisplayStatus;

@interface MyCalculatorViewController : UIViewController

@property (strong, nonatomic) CalculatorEngine *engine;
@property enum DisplayStatus displayStatus;

@end
