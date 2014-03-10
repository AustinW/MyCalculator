//
//  NSMutableArray+QueueAdditions.h
//  MyCalculator
//
//  Created by Austin White on 3/9/14.
//  Copyright (c) 2014 Austin White. All rights reserved.
//

@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end