//
//  ShuntingYard.h
//  MyCalculator
//
//  Created by Austin White on 3/9/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJGStack.h"
#import "NSMutableArray+QueueAdditions.h"

@interface ShuntingYard : NSObject

@property (nonatomic) MJGStack *stack;
@property (nonatomic) NSMutableArray *output;
@property NSDictionary *operators;

- (id) initWithOperators:(NSDictionary *)operators;
- (NSArray *) shuntingYardWithTokens:(NSArray *)tokens;

@end
