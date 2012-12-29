//
//  MECOViewController.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOViewController.h"
#import "MECOGroundView.h"
#import "MECOSpriteView.h"

@interface MECOViewController () <MECOSpriteViewDelegate>

@end

@implementation MECOViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithRed:153./255. green:255./255. blue:255./255. alpha:1.0];
	
	MECOGroundView *groundView = [MECOGroundView new];
	groundView.frame = (CGRect){
		{0, self.view.frame.size.height - 20},
		{self.view.frame.size.width, 20}
	};
	groundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	[self.view addSubview:groundView];
	
	for (NSUInteger i = 0; i < 4; i++) {
		MECOSpriteView *mecoView = [MECOSpriteView new];
		mecoView.delegate = self;
		mecoView.image = [UIImage imageNamed:@"Meco.png"];
		mecoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
		
		mecoView.center = (CGPoint){
			self.view.frame.size.width / 2.,
			self.view.frame.size.height - mecoView.frame.size.height
		};
		
		[self.view addSubview:mecoView];
	}
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


-(bool)spriteView:(MECOSpriteView *)spriteView shouldMoveToDestination:(CGPoint)destination {
	return
		(destination.x > CGRectGetMinX(self.view.frame))
	&&	(destination.x < CGRectGetMaxX(self.view.frame));
}

@end
