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

@property (weak) CALayer *imageLayer;

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
@synthesize imageLayer = _imageLayer;
-(void)fadeOutView:(UIImageView *)view{
	[UIImageView animateWithDuration:0.25 animations:^{
		view.alpha = 0;
	} completion:^(BOOL finished) {
		[view removeFromSuperview];
	}];
};
-(id)init {
	if ((self = [super init])) {
		[self resetTimer];
		
		UIImage *speechBubbleImage = [UIImage imageNamed:@"Surprise.png"];
		
		UIImageView *speechBubbleView = [[UIImageView alloc] initWithImage:speechBubbleImage];
		
		speechBubbleView.frame = (CGRect){
			{20, -20},
			speechBubbleView.bounds.size
		};
		
		[self addSubview: speechBubbleView];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[self fadeOutView:speechBubbleView];
		});
		
		CALayer *imageLayer = [CALayer layer];
		imageLayer.actions = [NSDictionary dictionaryWithObjectsAndKeys:
								   [NSNull null], @"transform",
								   nil];
		[self.layer addSublayer:imageLayer];
		self.imageLayer = imageLayer;
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
	return self.imageLayer.contents;
}

-(void)setImage:(UIImage *)image {
	self.imageLayer.bounds = self.bounds = (CGRect){
		.size = {
			image.size.width,
			image.size.height
		}
	};
	self.imageLayer.position = (CGPoint){
		CGRectGetMidX(self.layer.bounds),
		CGRectGetMidY(self.layer.bounds)
	};
	self.imageLayer.contents = (__bridge id)image.CGImage;
}


-(void)applyAcceleration:(CGPoint)acceleration {
	if (self.isFixed) return;
	
	self.inertia = MECOPointAdd(self.inertia, acceleration);
}

-(void)updateWithInterval:(NSTimeInterval)interval {
	if (self.isFixed) return;
	
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
	bool direction = random() % 2;
	CGFloat delta = direction? 1.0 : -1.0;
	NSTimeInterval duration = ((CGFloat)((random() % 3) + 1)) / 2.0;
	
	self.imageLayer.transform = CATransform3DMakeScale(delta, 1.0, 1.0);
	
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

@end
