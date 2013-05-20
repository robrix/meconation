//  MECOSpriteBehaviour.m
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOSpriteBehaviour.h"
#import "MECOSpriteView.h"
#import "MECOGeometry.h"

@implementation MECOGravity

-(void)applyToSprite:(MECOSpriteView *)sprite withInterval:(NSTimeInterval)interval {
	[sprite applyAcceleration:(CGPoint){
		.y = 9.8 * interval
	}];
}

@end


@interface MECOWanderingBehaviour ()
@property (strong) NSTimer *timer;
@property CGPoint velocity;
@end

@implementation MECOWanderingBehaviour

+(void)initialize {
	srandomdev();
}


-(instancetype)init {
	if ((self = [super init])) {
		[self resetTimer];
	}
	return self;
}

-(void)dealloc {
	[self.timer invalidate];
}


-(void)resetTimer {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerDidFire:) userInfo:nil repeats:NO];
}

-(void)timerDidFire:(NSTimer *)timer {
	bool direction = random() % 2;
	CGFloat delta = direction? 1.0 : -1.0;
	NSTimeInterval duration = ((CGFloat)((random() % 3) + 1)) / 2.0;
	
	self.velocity = MECOPointAdd(self.velocity, (CGPoint){
		.x = delta
	});
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		self.velocity = MECOPointAdd(self.velocity, (CGPoint){
			.x = -delta
		});
		[self resetTimer];
	});
}


-(void)applyToSprite:(MECOSpriteView *)sprite withInterval:(NSTimeInterval)interval {
	sprite.velocity = (CGPoint){
		self.velocity.x,
		sprite.velocity.y
	};
}

@end
