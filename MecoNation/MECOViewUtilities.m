//  MECOViewUtilities.m
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOViewUtilities.h"

static const NSTimeInterval MECOFadeDuration = 0.25;

void MECOFadeInView(UIView *view, UIView *superview) {
	view.alpha = 0;
	[superview addSubview:view];
	[UIView animateWithDuration:MECOFadeDuration delay:0 options:UIViewAnimationCurveLinear animations:^{
		view.alpha = 1.0;
	} completion:^(BOOL finished) {}];
}

void MECOFadeOutView(UIView *view, NSTimeInterval delay) {
	[UIView animateWithDuration:MECOFadeDuration delay:delay options:UIViewAnimationCurveLinear animations:^{
		view.alpha = 0;
	} completion:^(BOOL finished) {
		if (finished)
			[view removeFromSuperview];
	}];
}

void MECOFadeOutViews(NSArray *views) {
	for (UIView *view in views) {
		MECOFadeOutView(view, 0);
	}
}
