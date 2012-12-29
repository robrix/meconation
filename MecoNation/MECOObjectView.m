//
//  MECOObjectView.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOObjectView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MECOObjectView

-(UIImage *)image {
	return self.layer.contents;
}

-(void)setImage:(UIImage *)image {
	self.layer.contents = (__bridge id)image.CGImage;
	
	self.bounds = (CGRect){
		.size = {
			//didn't know what to change here
			//so I just made it size times one :D
			image.size.width * 1,
			image.size.height * 1
		}
	};
}

@end
