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


-(void)timerDidFire:(NSTimer *)timer {
	CGFloat direction = (random() % 2)? 1.0 : -1.0;
	CGFloat distance = ((CGFloat)((random() % 4) + 2)) * 20.0;
	CGFloat delta = direction * distance;
	NSTimeInterval duration = distance / 40.0;
	
	CGPoint start = self.center;
	CGPoint destination = (CGPoint){
		start.x + delta,
		start.y
	};
	
	if ([self.delegate spriteView:self shouldMoveToDestination:destination]) {
		self.layer.transform = CATransform3DMakeScale(direction, 1.0, 1.0);
		
		[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
			self.center = destination;
		} completion:^(BOOL finished) {
			[self resetTimer];
		}];
	} else {
		[self resetTimer];
	}
}

@end
