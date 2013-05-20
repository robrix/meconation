//  MECOViewUtilities.m
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOViewUtilities.h"

static const NSTimeInterval MECOFadeDuration = 0.25;

void MECOFadeInView(UIView *view, UIView *superview) {
	[UIView transitionWithView:superview duration:MECOFadeDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[superview addSubview:view];
	} completion:nil];
}

void MECOFadeOutView(UIView *view, NSTimeInterval delay) {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
		[UIView transitionWithView:view.superview duration:MECOFadeDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			[view removeFromSuperview];
		} completion:nil];
	});
}

void MECOFadeOutViews(NSArray *views) {
	for (UIView *view in views) {
		MECOFadeOutView(view, 0);
	}
}
