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
#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>

@interface MECOViewController () <MECOSpriteViewDelegate>

@property (strong) CADisplayLink *displayLink;

@property (strong) MECOGroundView *groundView;

@property (strong) NSMutableSet *sprites;

@property (strong) IBOutlet UIToolbar *toolbar;

@property (strong) IBOutlet UIBarButtonItem *IQCounter;

-(void)addMeco;

@end

#define MECOConstrainValueToRange(value, minimum, maximum) \
	MAX(MIN((value), (maximum)), (minimum))

@implementation MECOViewController

@synthesize displayLink = _displayLink;
@synthesize groundView = _groundView;
@synthesize sprites = _sprites;
@synthesize toolbar = _toolbar;
@synthesize IQCounter = _IQCounter;

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
	[self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
	
	self.sprites = [NSMutableSet new];
	
	self.view.backgroundColor = [UIColor colorWithRed:153./255. green:255./255. blue:255./255. alpha:1.0];
}


-(void)viewDidAppear:(BOOL)animated {
	
	self.groundView = [MECOGroundView new];
	self.groundView.frame = self.view.bounds;
	self.groundView.island = [MECOIsland firstIsland];
	self.groundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:self.groundView atIndex:0];
	
	self.toolbar.frame = (CGRect){
		.size = { self.view.bounds.size.width, 30 }
	};
	[self addMeco];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


-(bool)spriteView:(MECOSpriteView *)spriteView shouldMoveToDestination:(CGPoint)destination {
	return
		(destination.x > CGRectGetMinX(self.view.bounds))
	&&	(destination.x < CGRectGetMaxX(self.view.bounds));
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
	return [self constrainSpritePosition:[self constrainSpritePositionToGround:position] toRect:self.view.bounds];
}


-(IBAction)addMeco:(id)sender {
	[self addMeco];
}


-(void)addMeco {
	MECOSpriteView *mecoView = [MECOSpriteView new];
	mecoView.delegate = self;
	mecoView.image = [UIImage imageNamed:@"Meco.png"];
	mecoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
	
	CGPoint tile = (CGPoint){
		random() % (NSUInteger)(self.view.bounds.size.width / 20.0),
		random() % ((NSUInteger)((self.view.bounds.size.height / 20.0) - 3))+2
	};
	
	mecoView.center = (CGPoint){
		(tile.x * 20) + 10,
		(tile.y * 20) + 20
	};
	
	[self.sprites addObject:mecoView];
	[self.view insertSubview:mecoView belowSubview:self.toolbar];
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
