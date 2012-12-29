//
//  NSValue+MECOPoints.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-29.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "NSValue+MECOPoints.h"

@implementation NSValue (MECOPoints)

+(NSValue *)valueWithPoint:(CGPoint)point {
	return [self valueWithBytes:&point objCType:@encode(CGPoint)];
}

-(CGPoint)pointValue {
	CGPoint point;
	[self getValue:&point];
	return point;
}

@end
