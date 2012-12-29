//
//  NSValue+MECOPoints.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-29.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (MECOPoints)

+(NSValue *)valueWithPoint:(CGPoint)point;

-(CGPoint)pointValue;

@end
