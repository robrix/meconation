//
//  MECOViewController.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOViewController.h"

@interface MECOViewController ()

@end

@implementation MECOViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blueColor];
}


-(NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotate {
	return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
