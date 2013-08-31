//  MECOJobResponsibility.m
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOJobResponsibility.h"
#import "MECOResource.h"

@interface MECOEarningJobResponsibility ()

@property (nonatomic) MECOResourceRate *rate;
@property (nonatomic) NSTimer *timer;

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

-(void)personDidStart:(MECOPerson *)person {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:self.rate.interval target:self selector:@selector(timerDidFire:) userInfo:person repeats:YES];
}

-(void)personWillQuit:(MECOPerson *)person {
	[self.timer invalidate];
	self.timer = nil;
}

-(void)timerDidFire:(NSTimer *)timer {
	self.rate.resource.quantity += self.rate.quantity;
}

@end
