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

@property (strong) NSMutableSet *mutableMecos;
@property (strong) NSMutableSet *mutableHouses;

@end

@implementation MECOIsland

@synthesize bezierPath = _bezierPath;
@synthesize yValues = _yValues;

const CGSize gridSize = {20, 20};

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
	
	[bezierPath applyTransform:CGAffineTransformMakeScale(gridSize.width, -gridSize.height)];
	
	return bezierPath;
}

+(CGRect)boundsWithYValues:(NSArray *)yValues {
	CGRect bounds = {.size.width = yValues.count};
	for (NSNumber *yValue in yValues) {
		if (yValue.unsignedIntegerValue > 0)
			break;
		bounds.origin.x++;
		bounds.size.width--;
	}
	
	for (NSNumber *yValue in yValues) {
		bounds.size.height = MAX(bounds.size.height, yValue.unsignedIntegerValue);
	}
	
	for (NSNumber *yValue in yValues.reverseObjectEnumerator) {
		bounds.size.width--;
		if (yValue.unsignedIntegerValue > 0)
			break;
	}
	
	return CGRectApplyAffineTransform(bounds, CGAffineTransformMakeScale(gridSize.width, -gridSize.height));
}

+(NSArray *)houseLocationsForYValues:(NSArray *)yValues {
	NSMutableArray *houseLocations = [NSMutableArray new];
	NSUInteger run = 0;
	NSUInteger previousY = 0;
	NSInteger index = 0;
	NSInteger previousHouseBoundary = -1;
	const NSInteger houseWidth = 5;
	for (NSNumber *yValue in yValues) {
		NSUInteger currentY = yValue.unsignedIntegerValue;
		if (currentY == previousY)
			run++;
		else
			run = 0;
		
		if ((run >= houseWidth) && (currentY >= 2) && (previousHouseBoundary < (index - houseWidth))) {
			previousHouseBoundary = index;
			[houseLocations addObject:[NSValue valueWithCGPoint:(CGPoint){ (index - houseWidth) * gridSize.width, currentY * gridSize.height }]];
			run = 0;
		}
		
		previousY = currentY;
		index++;
	}
	return houseLocations;
}

+(instancetype)islandWithYValues:(NSArray *)yValues {
	MECOIsland *island = [self new];
	
	island.yValues = yValues;
	
	island.bezierPath = [self bezierPathWithYValues:yValues];
	island.bounds = [self boundsWithYValues:yValues];
	
	island.houseLocations = [self houseLocationsForYValues:yValues];
	
	return island;
}

-(instancetype)init {
	if ((self = [super init])) {
		_mutableMecos = [NSMutableSet new];
		_mutableHouses = [NSMutableSet new];
	}
	return self;
}

-(NSSet *)mecos {
	return self.mutableMecos;
}

-(void)addPerson:(MECOPerson *)person {
	[self.mutableMecos addObject:person];
	[self.delegate island:self didAddPerson:person];
}

-(void)removePerson:(MECOPerson *)person {
	[self.mutableMecos removeObject:person];
}


-(NSSet *)houses {
	return self.mutableHouses;
}

-(void)addHouse:(MECOHouse *)house {
	[self.mutableHouses addObject:house];
	[self.delegate island:self didAddHouse:house];
}

-(void)removeHouse:(MECOHouse *)house {
	[self.mutableHouses removeObject:house];
}


// linear intepolation between the y values immediately on either side of x
-(CGFloat)groundHeightAtX:(CGFloat)x {
	x /= gridSize.width;
	
	// if x isn’t valid for this island, return 0
	if (x < 0)
		return [self groundHeightAtX:0];
	if (x >= (self.yValues.count - 1))
		return [self groundHeightAtX:self.yValues.count - 1];
	
	float integral;
	float t = modff(x, &integral);
	CGFloat a = [[self.yValues objectAtIndex:(NSUInteger)integral] floatValue];
	CGFloat b = [[self.yValues objectAtIndex:(NSUInteger)integral + 1] floatValue];
	
	return (t * (b - a) + a) * gridSize.height;
}

@end
