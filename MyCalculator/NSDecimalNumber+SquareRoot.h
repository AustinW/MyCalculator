//
//  NSDecimalNumber+SquareRoot.h
//  CubeRoot
//
//  Created by Michael Taylor on 10-06-21.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (SquareRoot)

- (NSDecimalNumber *) squareRoot;
- (NSDecimalNumber *) cubeRoot;
- (NSDecimalNumber *) abs;
- (NSDecimalNumber *) sign;
- (BOOL) isEquivalentTo:(NSDecimalNumber*)number;

@end
