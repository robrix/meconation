//
//  MECOIsland.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-29.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOIsland.h"
#import "NSValue+MECOPoints.h"

@interface MECOIsland ()

@property (copy) NSArray *yValues;

+(id)islandWithYValues:(NSArray *)yValues;

@end

@implementation MECOIsland

@synthesize bezierPath = _bezierPath;
@synthesize yValues = _yValues;


+(NSArray *)allIslands {
	static NSMutableArray *allIslands = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSString *path = nil;
		allIslands = [NSMutableArray new];
		NSUInteger islandIndex = 1;
		while ((path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Island %u", islandIndex] ofType:@"plist"]) != nil) {
			[allIslands addObject:[self islandWithYValues:[NSArray arrayWithContentsOfFile:path]]];
			islandIndex++;
		}
	});
	return allIslands;
}

+(UIBezierPath *)bezierPathWithYValues:(NSArray *)yValues {
	UIBezierPath *bezierPath = [UIBezierPath new];
	[bezierPath moveToPoint:CGPointZero];
	
	NSUInteger x = 0;
	for (NSNumber *yValue in yValues) {
		[bezierPath addLineToPoint:(CGPoint){ x++, yValue.unsignedIntegerValue }];
	}
	
	[bezierPath addLineToPoint:(CGPoint){ bezierPath.currentPoint.x, 0 }];
	[bezierPath closePath];
	[bezierPath applyTransform:CGAffineTransformMakeScale(20, -20)];
	
	return bezierPath;
}

+(id)islandWithYValues:(NSArray *)yValues {
	MECOIsland *island = [self new];
	
	island.yValues = yValues;
	
	island.bezierPath = [self bezierPathWithYValues:yValues];
	
	return island;
}


// linear intepolation between the y values immediately on either side of x
-(CGFloat)groundHeightAtX:(CGFloat)x {
	x /= 20.;
	
	// if x isn’t valid for this island, return 0
	if (x < 0)
		return 0;
	if (x >= (self.yValues.count - 1))
		return 0;
	
	float integral;
	float t = modff(x, &integral);
	CGFloat a = [[self.yValues objectAtIndex:(NSUInteger)integral] floatValue];
	CGFloat b = [[self.yValues objectAtIndex:(NSUInteger)integral + 1] floatValue];
	
	return (t * (b - a) + a) * 20.;
}

@end
