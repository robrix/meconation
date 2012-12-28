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
			image.size.width * 2,
			image.size.height * 2
		}
	};
}

@end
