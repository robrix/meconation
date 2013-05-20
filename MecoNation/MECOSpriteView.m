//
//  MECOSpriteView.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOSpriteBehaviour.h"
#import "MECOSpriteView.h"
#import "MECOGeometry.h"
#import "MECOViewUtilities.h"
#import <QuartzCore/QuartzCore.h>
#import <stdlib.h>


@interface MECOSpriteView ()
@end

@implementation MECOSpriteView

+(instancetype)spriteWithImage:(UIImage *)image {
	return [[self alloc] initWithImage:image];
}

-(instancetype)initWithImage:(UIImage *)image {
	if ((self = [super initWithImage:image])) {
		UIImage *speechBubbleImage = [UIImage imageNamed:@"Surprise.png"];
		
		UIImageView *speechBubbleView = [[UIImageView alloc] initWithImage:speechBubbleImage];
		
		speechBubbleView.frame = (CGRect){
			{20, -20},
			speechBubbleView.bounds.size
		};
		
		[self addSubview: speechBubbleView];
		MECOFadeOutView(speechBubbleView, 3);
		
		self.userInteractionEnabled = YES;
	}
	return self;
}


-(void)setImage:(UIImage *)image {
	super.image = image;
	[self sizeToFit];
}


-(void)applyAcceleration:(CGPoint)acceleration {
	self.inertia = MECOPointAdd(self.inertia, acceleration);
}

-(void)updateWithInterval:(NSTimeInterval)interval {
	for (id<MECOSpriteBehaviour> behaviour in self.behaviours) {
		[behaviour applyToSprite:self withInterval:interval];
	}
	
	self.velocity = MECOPointAdd(self.velocity, MECOPointScale(self.inertia, interval));
	
	// make the sprite face the direction of travel
	if (self.velocity.x != 0) {
		bool shouldFlip = self.velocity.x < 0;
		self.image = [UIImage imageWithCGImage:self.image.CGImage scale:self.image.scale orientation:shouldFlip? UIImageOrientationUpMirrored : UIImageOrientationUp];
	}
	
	CGPoint proposedCenter = MECOPointAdd(self.center, self.velocity);
	CGPoint constrainedCenter = self.delegate? [self.delegate spriteView:self constrainPosition:proposedCenter] : proposedCenter;
	
	CGPoint inertia = self.inertia;
	
	if ((constrainedCenter.x == self.center.x) && (inertia.x != 0))
		inertia.x = 0;
	if ((constrainedCenter.y == self.center.y) && (inertia.y != 0))
		inertia.y = 0;
	
	self.inertia = inertia;
	
	self.center = constrainedCenter;
}

@end
