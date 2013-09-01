//
//  MECOResource.m
//  MecoNation
//
//  Created by Rob Rix on 8/30/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOResource.h"

@implementation MECOResource

+(instancetype)resourceWithName:(NSString *)name {
	return [[self alloc] initWithName:name];
}

-(instancetype)initWithName:(NSString *)name {
	if ((self = [super init])) {
		_name = [name copy];
	}
	return self;
}


-(void)setQuantity:(float)quantity {
	_quantity = quantity;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MECOResourceDidChangeNotification object:self];
}

@end

NSString * const MECOResourceDidChangeNotification = @"MECOResourceDidChangeNotification";


@implementation MECOResourceRate

+(instancetype)rateWithResource:(MECOResource *)resource quantity:(float)quantity interval:(NSTimeInterval)interval {
	return [[self alloc] initWithResource:resource quantity:quantity interval:interval];
}

-(instancetype)initWithResource:(MECOResource *)resource quantity:(float)quantity interval:(NSTimeInterval)interval {
	if ((self = [super init])) {
		_resource = resource;
		_quantity = quantity;
		_interval = interval;
	}
	return self;
}

@end
