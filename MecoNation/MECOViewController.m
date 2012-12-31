//
//  MECOViewController.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOViewController.h"
#import "MECOGroundView.h"
#import "MECOIsland.h"
#import "MECOSpriteView.h"
#import "MECOPerson.h"
#import "MECOJob.h"
#import "RXOptionSheet.h"
#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>

@interface MECOViewController () <MECOSpriteViewDelegate, UIActionSheetDelegate>

@property (strong) CADisplayLink *displayLink;

@property (strong) MECOGroundView *groundView;

@property (strong) NSMutableSet *sprites;

@property (strong) NSMutableSet *mecos;

@property (weak) IBOutlet UIScrollView *scrollView;

@property (strong) IBOutlet UIToolbar *toolbar;

@property (strong) IBOutlet UIBarButtonItem *IQCounter;

-(void)addMecoWithJob:(MECOJob *)job;

@property (readonly) CGRect validBoundsForMecos;

@end

#define MECOConstrainValueToRange(value, minimum, maximum) \
	MAX(MIN((value), (maximum)), (minimum))

@implementation MECOViewController

@synthesize displayLink = _displayLink;
@synthesize groundView = _groundView;
@synthesize sprites = _sprites;
@synthesize mecos = _mecos;
@synthesize toolbar = _toolbar;
@synthesize IQCounter = _IQCounter;
@synthesize scrollView = _scrollView;

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
	[self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
	
	self.sprites = [NSMutableSet new];
	self.mecos = [NSMutableSet new];
		
	self.view.backgroundColor = [UIColor colorWithRed:153./255. green:255./255. blue:255./255. alpha:1.0];
}

-(void)viewDidAppear:(BOOL)animated {
	MECOIsland *island = [MECOIsland firstIsland];
	self.scrollView.contentSize = (CGSize){
		MAX(island.bezierPath.bounds.size.width, self.scrollView.bounds.size.width),
		MAX(island.bezierPath.bounds.size.height, self.scrollView.bounds.size.height),
	};
	self.groundView = [MECOGroundView new];
	self.groundView.frame = self.scrollView.bounds;
	self.groundView.island = island;
	self.groundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.scrollView insertSubview:self.groundView atIndex:0];
	
	self.toolbar.frame = (CGRect){
		.size = { self.view.bounds.size.width, 30 }
	};
	[self addMecoWithJob:[MECOJob jobTitled:MECOScientistJobTitle]];
	[self addMecoWithJob:[MECOJob jobTitled:MECOFarmerJobTitle]];
	[self addMecoWithJob:[MECOJob jobTitled:MECOTailorJobTitle]];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


-(CGRect)validBoundsForMecos {
	return (CGRect){
		{},
		self.scrollView.contentSize
	};
}


-(bool)spriteView:(MECOSpriteView *)spriteView shouldMoveToDestination:(CGPoint)destination {
	return
		(destination.x > CGRectGetMinX(self.validBoundsForMecos))
	&&	(destination.x < CGRectGetMaxX(self.validBoundsForMecos));
}

-(CGPoint)constrainSpritePosition:(CGPoint)position toRect:(CGRect)bounds {
	return (CGPoint){
		MECOConstrainValueToRange(position.x, CGRectGetMinX(bounds), CGRectGetMaxX(bounds)),
		MECOConstrainValueToRange(position.y, CGRectGetMinY(bounds), CGRectGetMaxY(bounds))
	};
}

-(CGPoint)constrainSpritePositionToGround:(CGPoint)position {
	return (CGPoint){
		position.x,
		MECOConstrainValueToRange(position.y, 0, (CGRectGetHeight(self.groundView.bounds) - [self.groundView.island groundHeightAtX:position.x]) - 20)
	};
}

-(CGPoint)spriteView:(MECOSpriteView *)spriteView constrainPosition:(CGPoint)position {
	return [self constrainSpritePosition:[self constrainSpritePositionToGround:position] toRect:self.validBoundsForMecos];
}


-(IBAction)addMeco:(id)sender {
	[self addMecoWithJob:nil];
}

-(void)showMecosMenuForJob:(MECOJob *)job {
	NSArray *mecos = [self.mecos sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	
	RXOptionSheet *optionSheet = [RXOptionSheet sheetWithTitle:[NSString stringWithFormat:@"Select a Meco to make a %@", job.title] options:mecos optionTitleKeyPath:@"label" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, MECOPerson *meco) {
		MECOSpriteView *mecoView = meco.sprite;
		meco.job = job;
		mecoView.image = job.costumeImage;
	}];
	
	[optionSheet showFromRect:self.toolbar.bounds inView:self.toolbar animated:YES];
}

-(IBAction)showJobsMenu:(id)sender {
	RXOptionSheet *optionSheet = [RXOptionSheet sheetWithTitle:@"Jobs" options:[MECOJob allJobs] optionTitleKeyPath:@"title" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, MECOJob *selectedJob) {
		[self showMecosMenuForJob:selectedJob];
	}];
	
	[optionSheet showFromRect:self.toolbar.bounds inView:self.toolbar animated:YES];
}


-(void)addMecoWithJob:(MECOJob *)job {
	job = job ?: [MECOJob jobTitled:MECOUnemployedJobTitle];
	MECOPerson *meco = [MECOPerson personWithName:[MECOPerson randomName] job:job];
	[self.mecos addObject:meco];
	
	MECOSpriteView *mecoView = [MECOSpriteView new];
	mecoView.delegate = self;
	mecoView.image = job.costumeImage;
	mecoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
	
	CGPoint tile = (CGPoint){
		random() % (NSUInteger)(self.scrollView.contentSize.width / 20.0),
		random() % ((NSUInteger)((self.scrollView.contentSize.height / 20.0) - 3) + 2)
	};
	
	mecoView.center = (CGPoint){
		(tile.x * 20) + 10,
		(tile.y * 20) + 20
	};
	
	[self.sprites addObject:mecoView];
	
	meco.sprite = mecoView;
	mecoView.actor = meco;
	
	[mecoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMeco:)]];
	
	[self.scrollView insertSubview:mecoView belowSubview:self.toolbar];
}

-(void)fadeView:(UIView *)view intoSuperview:(UIView *)superview {
	view.alpha = 0;
	[superview addSubview:view];
	[UIView animateWithDuration:0.25 animations:^{
		view.alpha = 1;
	}];
}

-(void)fadeOutView:(UIView *)view {
	[UIView animateWithDuration:0.25 animations:^{
		view.alpha = 0;
	} completion:^(BOOL finished) {
		[view removeFromSuperview];
	}];
}

-(void)fadeOutViews:(NSArray *)views {
	for (UIView *view in views) {
		[self fadeOutView:view];
	}
}

-(void)didTapMeco:(UITapGestureRecognizer *)tap {
	MECOSpriteView *view = (MECOSpriteView *)tap.view;
	if (view.subviews.count) {
		[self fadeOutView:view.subviews.lastObject];
	} else {
		[self fadeOutViews:[self.sprites valueForKeyPath:@"@distinctUnionOfArrays.subviews"]];
		
		MECOPerson *meco = view.actor;
		
		[self.view bringSubviewToFront:view];
		
		UILabel *info = [UILabel new];
		info.text = [NSString stringWithFormat:@"%@ (%@)", meco.name, meco.job.title ?: @"Unemployed"];
		info.backgroundColor = [UIColor clearColor];
		info.textColor = [UIColor blackColor];
		info.textAlignment = UITextAlignmentCenter;
		[info sizeToFit];
		info.center = (CGPoint){
			CGRectGetMidX(view.bounds),
			-(CGRectGetHeight(info.bounds) + 2)
		};
		[self fadeView:info intoSuperview:view];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[self fadeOutView:info];
		});
	}
}



-(void)tick:(CADisplayLink *)displayLink {
	for (MECOSpriteView *sprite in self.sprites) {
		[sprite applyAcceleration:(CGPoint){
			0,
			9.8 * displayLink.duration
		}];
		
		[sprite updateWithInterval:displayLink.duration];
	}
}

@end
