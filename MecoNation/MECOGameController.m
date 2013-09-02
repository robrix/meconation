//
//  MECOGameController.m
//  MecoNation
//
//  Created by Rob Rix on 8/31/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOGameController.h"

#import "MECOJob.h"
#import "MECOPerson.h"
#import "MECOWorld.h"

#import <QuartzCore/QuartzCore.h>

@interface MECOGameController ()

@property (nonatomic, readonly) CADisplayLink *displayLink;
@property (nonatomic, readonly) NSMutableSet *mutableActors;

@property (nonatomic) id willQuitObserver;
@property (nonatomic) id didStartObserver;

@property (nonatomic, readonly) NSTimeInterval timeScale;

@end

@implementation MECOGameController

-(instancetype)init {
	if ((self = [super init])) {
		__weak MECOGameController *weakSelf = self;
		_didStartObserver = [[NSNotificationCenter defaultCenter] addObserverForName:MECOPersonDidStartJobNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			MECOPerson *person = note.object;
			MECOGameController *self = weakSelf;
			for (id<MECOJobResponsibility> responsibility in person.job.responsibilities) {
				[self addActorsObject:responsibility];
			}
		}];
		
		_willQuitObserver = [[NSNotificationCenter defaultCenter] addObserverForName:MECOPersonWillQuitJobNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			MECOPerson *person = note.object;
			MECOGameController *self = weakSelf;
			for (id<MECOJobResponsibility> responsibility in person.job.responsibilities) {
				[self removeActorsObject:responsibility];
			}
		}];
		
		_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
		_displayLink.paused = YES;
		[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
		
		_mutableActors = [NSMutableSet new];
	}
	return self;
}

-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:_willQuitObserver];
	[[NSNotificationCenter defaultCenter] removeObserver:_didStartObserver];
}


#pragma mark Actors

-(NSSet *)actors {
	return self.mutableActors;
}

-(void)setActors:(NSSet *)actors {
	self.mutableActors.set = actors;
}

-(void)addActorsObject:(id<MECOActor>)actor {
	[self.mutableActors addObject:actor];
}

-(void)removeActorsObject:(id<MECOActor>)actor {
	[self.mutableActors removeObject:actor];
}


#pragma mark Pausing

+(NSSet *)keyPathsForValuesAffectingPaused {
	return [NSSet setWithObject:@"paused"];
}

-(bool)isPaused {
	return self.displayLink.paused;
}

-(void)setPaused:(bool)paused {
	self.displayLink.paused = paused;
	
	for (id<MECOActor> actor in self.actors) {
		if (paused && [actor respondsToSelector:@selector(gameControllerDidPause:)] ) {
			[actor gameControllerDidPause:self];
		} else if (!paused && [actor respondsToSelector:@selector(gameControllerDidResume:)]) {
			[actor gameControllerDidResume:self];
		}
	}
}


#pragma mark Game loop

-(NSTimeInterval)timeScale {
	return 1.0;
}

-(void)tick:(CADisplayLink *)displayLink {
	for (id<MECOActor> actor in self.actors) {
		[actor gameController:self updateWithInterval:displayLink.duration * self.timeScale];
	}
}

@end
