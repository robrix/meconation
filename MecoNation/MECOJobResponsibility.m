//  MECOJobResponsibility.m
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOJobResponsibility.h"

//----------------------------------------------
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
	self.world.IQResource.quantity += self.IQRate;
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


-(float)woodRate {
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
	self.world.woodResource.quantity += self.woodRate;
}

@end

//-----------------------------------------------------
@interface MECOMinerJobResponsibility ()
@property NSTimer *timer;
@property (strong, readwrite) id<MECOWorld> world;
@end

@implementation MECOMinerJobResponsibility

@synthesize world = _world;

+(instancetype)responsibilityWithWorld:(id<MECOWorld>)world {
	MECOMinerJobResponsibility *responsibility = [self new];
	responsibility.world = world;
	return responsibility;
}


-(float)stoneRate {
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
	self.world.stoneResource.quantity += self.stoneRate;
}

@end

//-----------------------------------------------------
@interface MECOFishermanJobResponsibility ()
@property NSTimer *timer;
@property (strong, readwrite) id<MECOWorld> world;
@end

@implementation MECOFishermanJobResponsibility

@synthesize world = _world;

+(instancetype)responsibilityWithWorld:(id<MECOWorld>)world {
	MECOFishermanJobResponsibility *responsibility = [self new];
	responsibility.world = world;
	return responsibility;
}


-(float)foodRate {
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
	self.world.foodResource.quantity += self.foodRate;
}

@end
//-----------------------------------------------------
@interface MECOFarmerJobResponsibility ()
@property NSTimer *timer;
@property (strong, readwrite) id<MECOWorld> world;
@end

@implementation MECOFarmerJobResponsibility

@synthesize world = _world;

+(instancetype)responsibilityWithWorld:(id<MECOWorld>)world {
	MECOFarmerJobResponsibility *responsibility = [self new];
	responsibility.world = world;
	return responsibility;
}


-(float)foodRate {
	return 10.0;
}

-(float)woolRate {
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
	self.world.foodResource.quantity += self.foodRate;
	self.world.woolResource.quantity += self.woolRate;
}

@end
