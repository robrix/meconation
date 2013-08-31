//  MECOHouse.m
//  Created by Rob Rix on 2013-05-19.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOHouse.h"

@implementation MECOHouse

+(instancetype)houseWithLocation:(CGPoint)location {
	return [[self alloc] initWithLocation:location];
}

-(instancetype)initWithLocation:(CGPoint)location {
	if ((self = [super init])) {
		_location = location;
	}
	return self;
}

@end
