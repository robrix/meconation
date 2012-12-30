//
//  MECOSpriteView.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOSpriteView.h"
#import <QuartzCore/QuartzCore.h>
#import <stdlib.h>


static inline CGPoint MECOPointAdd(CGPoint a, CGPoint b) {
	return (CGPoint){ a.x + b.x, a.y + b.y };
}

static inline CGPoint MECOPointScale(CGPoint a, CGFloat t) {
	return (CGPoint){ a.x * t, a.y * t };
}


@interface MECOSpriteView ()

@property (strong) NSTimer *timer;

-(void)resetTimer;

@end

@implementation MECOSpriteView

+(void)initialize {
	srandomdev();
}

@synthesize timer = _timer;
@synthesize delegate = _delegate;
@synthesize velocity = _velocity;
@synthesize inertia = _inertia;
@synthesize actor = _actor;

-(id)init {
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


-(UIImage *)image {
	return self.layer.contents;
}

-(void)setImage:(UIImage *)image {
	self.layer.contents = (__bridge id)image.CGImage;
	
	self.bounds = (CGRect){
		.size = {
			image.size.width,
			image.size.height
		}
	};
}


-(void)applyAcceleration:(CGPoint)acceleration {
	self.inertia = MECOPointAdd(self.inertia, acceleration);
}

-(void)updateWithInterval:(NSTimeInterval)interval {
	self.velocity = MECOPointAdd(self.velocity, MECOPointScale(self.inertia, interval));
	
	CGPoint proposedCenter = MECOPointAdd(self.center, self.velocity);
	CGPoint constrainedCenter = [self.delegate spriteView:self constrainPosition:proposedCenter];
	
	CGPoint inertia = self.inertia;
	
	if ((constrainedCenter.x == self.center.x) && (inertia.x != 0))
		inertia.x = 0;
	if ((constrainedCenter.y == self.center.y) && (inertia.y != 0))
		inertia.y = 0;
	
	self.inertia = inertia;
	
	self.center = constrainedCenter;
}


-(void)timerDidFire:(NSTimer *)timer {
	CGFloat direction = (random() % 2)? 1.0 : -1.0;
	NSTimeInterval duration = ((CGFloat)((random() % 3) + 1)) / 2.0;
	
	self.layer.transform = CATransform3DMakeScale(direction, 1.0, 1.0);
	
	self.velocity = MECOPointAdd(self.velocity, (CGPoint){
		.x = direction
	});
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		self.velocity = MECOPointAdd(self.velocity, (CGPoint){
			.x = -direction
		});
		[self resetTimer];
	});
}

@end
