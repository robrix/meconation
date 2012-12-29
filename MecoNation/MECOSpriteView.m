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
	
	self.center = [self.delegate spriteView:self constrainPosition:MECOPointAdd(self.center, self.velocity)];
}


-(void)timerDidFire:(NSTimer *)timer {
	CGFloat direction = (random() % 2)? 1.0 : -1.0;
	CGFloat distance = ((CGFloat)((random() % 4) + 2)) * 20.0;
	CGFloat delta = direction * distance;
	NSTimeInterval duration = distance / 40.0;
	
	CGPoint start = self.center;
	CGPoint destination = [self.delegate spriteView:self constrainPosition:(CGPoint){
		start.x + delta,
		start.y
	}];
	
	self.layer.transform = CATransform3DMakeScale(direction, 1.0, 1.0);
	
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
		self.center = destination;
	} completion:^(BOOL finished) {
		[self resetTimer];
	}];
}

@end
