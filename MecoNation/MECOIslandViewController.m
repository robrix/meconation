//
//  MECOViewController.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOIslandViewController.h"
#import "MECOGroundView.h"
#import "MECOIsland.h"
#import "MECOSpriteView.h"
#import "MECOPerson.h"
#import "MECOJob.h"
#import "RXOptionSheet.h"
#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>

@interface MECOIslandViewController () <MECOSpriteViewDelegate, UIActionSheetDelegate>

@property (strong) CADisplayLink *displayLink;

@property (strong) MECOGroundView *groundView;

@property (strong) NSMutableSet *sprites;

@property (strong) NSMutableSet *mecos;

//@property (weak) IBOutlet UIScrollView *scrollView;

-(void)addMecoWithJob:(MECOJob *)job;
@property (nonatomic, readonly) UIView *viewForMenu;

@property (readonly) CGRect validBoundsForMecos;

@end

#define MECOConstrainValueToRange(value, minimum, maximum) \
	MAX(MIN((value), (maximum)), (minimum))

@implementation MECOIslandViewController

@synthesize island = _island;
@synthesize islandIndex = _islandIndex;
@synthesize displayLink = _displayLink;
@synthesize groundView = _groundView;
@synthesize sprites = _sprites;
@synthesize mecos = _mecos;
//@synthesize scrollView = _scrollView;

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
	[self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
	
	self.sprites = [NSMutableSet new];
	self.mecos = [NSMutableSet new];
}


-(void)setIsland:(MECOIsland *)island {
	_island = island;
	
	self.groundView = [MECOGroundView new];
	self.view.frame = self.groundView.frame = (CGRect){
		{},
		{MAX(CGRectGetWidth(self.island.bezierPath.bounds), CGRectGetWidth(self.view.bounds)), (CGRectGetHeight(self.island.bezierPath.bounds), CGRectGetHeight(self.view.bounds))}
	};
	self.groundView.island = self.island;
	self.groundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:self.groundView];
	
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
		self.groundView.bounds.size
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


// move these responsibilities to the world view controller
-(IBAction)addMeco:(id)sender {
	[self addMecoWithJob:nil];
}

-(UIView *)viewForMenu {
	return self.view.window.rootViewController.view;
}

-(void)showMecosMenuForJob:(MECOJob *)job {
	NSArray *mecos = [self.mecos sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	
	RXOptionSheet *optionSheet = [RXOptionSheet sheetWithTitle:[NSString stringWithFormat:@"Select a Meco to make a %@", job.title] options:mecos optionTitleKeyPath:@"label" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, MECOPerson *meco) {
		MECOSpriteView *mecoView = meco.sprite;
		meco.job = job;
		mecoView.image = job.costumeImage;
	}];
	
	[optionSheet showFromRect:self.viewForMenu.bounds inView:self.viewForMenu animated:YES];
}

-(IBAction)showJobsMenu:(id)sender {
	RXOptionSheet *optionSheet = [RXOptionSheet sheetWithTitle:@"Jobs" options:[MECOJob allJobs] optionTitleKeyPath:@"title" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, MECOJob *selectedJob) {
		[self showMecosMenuForJob:selectedJob];
	}];
	
	[optionSheet showFromRect:self.viewForMenu.bounds inView:self.viewForMenu animated:YES];
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
		random() % (NSUInteger)(CGRectGetWidth(self.view.bounds) / 20.0),
		random() % ((NSUInteger)((CGRectGetHeight(self.view.bounds) / 20.0) - 3) + 2)
	};
	
	mecoView.center = (CGPoint){
		(tile.x * 20) + 10,
		(tile.y * 20) + 20
	};
	
	[self.sprites addObject:mecoView];
	
	meco.sprite = mecoView;
	mecoView.actor = meco;
	
	[mecoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMeco:)]];
	
	[self.view addSubview:mecoView];
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
