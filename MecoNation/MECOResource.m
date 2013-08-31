//
//  MECOResource.m
//  MecoNation
//
//  Created by Rob Rix on 8/30/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOResource.h"

@interface MECOResource ()

@property (copy) MECOResourceObservationBlock block;

@end

@implementation MECOResource

+(instancetype)resourceWithName:(NSString *)name onChange:(MECOResourceObservationBlock)block {
	return [[self alloc] initWithName:name onChange:block];
}

-(instancetype)initWithName:(NSString *)name onChange:(MECOResourceObservationBlock)block {
	if ((self = [super init])) {
		_name = [name copy];
		_block = [block copy];
	}
	return self;
}


-(void)setQuantity:(float)quantity {
	_quantity = quantity;
	
	if (self.block)
		self.block(self);
}

@end


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
