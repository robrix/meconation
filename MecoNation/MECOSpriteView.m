//
//  MECOSpriteView.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOSpriteView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MECOSpriteView

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

@end
