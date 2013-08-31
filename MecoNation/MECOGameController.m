//
//  MECOGameController.m
//  MecoNation
//
//  Created by Rob Rix on 8/31/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOGameController.h"

@interface MECOGameController ()

@property (nonatomic, readonly) CADisplayLink *displayLink;
@property (nonatomic, readonly) NSMutableSet *mutableActors;

@end

@implementation MECOGameController

-(instancetype)initWithWorld:(MECOWorld *)world {
	if ((self = [super init])) {
		_world = world;
		
		_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
		_displayLink.paused = YES;
		[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
		
		_mutableActors = [NSMutableSet new];
	}
	return self;
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

-(void)tick:(CADisplayLink *)displayLink {
	for (id<MECOActor> actor in self.actors) {
		[actor gameController:self updateWithInterval:displayLink.duration];
	}
}

@end
