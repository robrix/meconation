//  MECOJobResponsibility.m
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOJobResponsibility.h"

@interface MECOScientistJobResponsibility ()
@property NSTimer *timer;
@property (strong, readwrite) id<MECOWorld> world;
@end

@implementation MECOScientistJobResponsibility

@synthesize world = _world;

+(instancetype)responsibilityWithWorld:(id<MECOWorld>)world {
	MECOScientistJobResponsibility *responsibility = [self new];
	responsibility.world = world;
	return responsibility;
}


-(float)IQRate {
	return 10.0;
}

-(void)personWillQuit:(MECOPerson *)person {
	[self.timer invalidate];
	self.timer = nil;
}

-(void)personDidStart:(MECOPerson *)person {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerDidFire:) userInfo:person repeats:YES];
}


-(void)timerDidFire:(NSTimer *)timer {
	self.world.IQ += self.IQRate;
}

@end

@implementation MECOMadScientistJobResponsibility

-(float)IQRate {
	return super.rate * 2.0;
}

@end

//-----------------------------------------------------
@interface MECOLumberjackJobResponsibility ()
@property NSTimer *timer;
@property (strong, readwrite) id<MECOWorld> world;
@end

@implementation MECOLumberjackJobResponsibility

@synthesize world = _world;

+(instancetype)responsibilityWithWorld:(id<MECOWorld>)world {
	MECOLumberjackJobResponsibility *responsibility = [self new];
	responsibility.world = world;
	return responsibility;
}


-(float)WoodRate {
	return 10.0;
}

-(void)personWillQuit:(MECOPerson *)person {
	[self.timer invalidate];
	self.timer = nil;
}

-(void)personDidStart:(MECOPerson *)person {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerDidFire:) userInfo:person repeats:YES];
}


-(void)timerDidFire:(NSTimer *)timer {
	self.world.wood += self.WoodRate;
}

@end

