//  MECOJobResponsibility.m
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOJobResponsibility.h"
#import "MECOResource.h"

@interface MECOEarningJobResponsibility ()

@property (nonatomic) MECOResourceRate *rate;
@property (nonatomic) NSTimeInterval elapsedInterval;

@end

@implementation MECOEarningJobResponsibility

+(instancetype)responsibilityWithDictionary:(NSDictionary *)dictionary world:(MECOWorld *)world {
	float quantity = [dictionary[@"quantity"] floatValue];
	NSTimeInterval interval = [dictionary[@"interval"] doubleValue];
	NSString *resourceKeyPath = [NSString stringWithFormat:@"%@Resource", dictionary[@"resource"]];
	MECOResource *resource = [(id)world valueForKeyPath:resourceKeyPath];
	MECOResourceRate *rate = [MECOResourceRate rateWithResource:resource quantity:quantity interval:interval];
	return [self responsibilityWithRate:rate];
}

+(instancetype)responsibilityWithRate:(MECOResourceRate *)rate {
	return [[self alloc] initWithRate:rate];
}

-(instancetype)initWithRate:(MECOResourceRate *)rate {
	if ((self = [super init])) {
		_rate = rate;
	}
	return self;
}

-(void)personDidStart:(MECOPerson *)person {}

-(void)personWillQuit:(MECOPerson *)person {}


#pragma mark MECOActor

-(void)gameController:(MECOGameController *)gameController updateWithInterval:(NSTimeInterval)interval {
	self.elapsedInterval += interval;
	if (self.elapsedInterval >= self.rate.interval) {
		self.elapsedInterval -= self.rate.interval;
		self.rate.resource.quantity += self.rate.quantity;
	}
}

@end
