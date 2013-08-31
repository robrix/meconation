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
#import "MECOSpriteBehaviour.h"
#import "MECOPerson.h"
#import "MECOHouse.h"
#import "MECOJob.h"
#import "RXOptionSheet.h"
#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import "MECOWorldViewController.h"
#import "MECOViewUtilities.h"

@interface MECOIslandViewController () <MECOSpriteViewDelegate, UIActionSheetDelegate, MECOIslandDelegate, MECOPersonDelegate>

@property (strong) MECOGroundView *groundView;

@property (strong) NSMutableSet *sprites;

@property (readonly) CGRect validBoundsForMecos;

@end

#define MECOConstrainValueToRange(value, minimum, maximum) \
	MAX(MIN((value), (maximum)), (minimum))

@implementation MECOIslandViewController

@synthesize island = _island;
@synthesize islandIndex = _islandIndex;
@synthesize groundView = _groundView;
@synthesize sprites = _sprites;

-(void)configureWithIslandAtIndex:(NSUInteger)index inWorld:(MECOWorld *)world {
	_world = world;
	_islandIndex = index;
	_island = world.islands[index];
	_island.delegate = self;
	
	self.groundView = [MECOGroundView new];
	self.view.frame = self.groundView.frame = (CGRect){
		{},
		{MAX(CGRectGetWidth(_island.bezierPath.bounds), CGRectGetWidth(self.view.bounds)), (CGRectGetHeight(_island.bezierPath.bounds), CGRectGetHeight(self.view.bounds))}
	};
	self.groundView.island = _island;
	self.groundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:self.groundView];
	
	for (MECOPerson *person in _island.mecos) {
		[self addSpriteForPerson:person];
	}
	
	for (MECOHouse *house in _island.houses) {
		[self addSpriteForHouse:house];
	}
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.sprites = [NSMutableSet new];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


-(CGRect)validBoundsForMecos {
	CGRect islandBounds = self.island.bounds;
	return (CGRect){
		{islandBounds.origin.x, 0},
		{islandBounds.size.width, self.groundView.bounds.size.height}
	};
}


-(CGPoint)constrainSprite:(MECOSpriteView *)sprite position:(CGPoint)position toRect:(CGRect)bounds {
	return (CGPoint){
		MECOConstrainValueToRange(position.x, CGRectGetMinX(bounds), CGRectGetMaxX(bounds)),
		MECOConstrainValueToRange(position.y, CGRectGetMinY(bounds), CGRectGetMaxY(bounds))
	};
}

-(CGPoint)constrainSpriteToGround:(MECOSpriteView *)sprite withPosition:(CGPoint)position {
	return (CGPoint){
		position.x,
		MECOConstrainValueToRange(position.y, 0, (CGRectGetHeight(self.groundView.bounds) - [self.groundView.island groundHeightAtX:position.x]) - CGRectGetHeight(sprite.bounds) / 2.0)
	};
}

-(CGPoint)spriteView:(MECOSpriteView *)sprite constrainPosition:(CGPoint)position {
	return [self constrainSpriteToGround:sprite withPosition:[self constrainSprite:sprite position:position toRect:self.validBoundsForMecos]];
}

-(void)didTapMeco:(UITapGestureRecognizer *)tap {
	MECOSpriteView *view = (MECOSpriteView *)tap.view;
	if (view.subviews.count) {
		MECOFadeOutView(view.subviews.lastObject, 0);
	} else {
		MECOFadeOutViews([self.sprites valueForKeyPath:@"@distinctUnionOfArrays.subviews"]);
		
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
		MECOFadeInView(info, view);
		MECOFadeOutView(info, 3);
	}
}

-(void)addSpriteForPerson:(MECOPerson *)person {
	MECOSpriteView *mecoView = [MECOSpriteView spriteWithImage:person.job.costumeImage];
	mecoView.delegate = self;
	mecoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
	
	CGPoint tile = (CGPoint){
		random() % (NSUInteger)(CGRectGetWidth(self.view.bounds) / 20.0),
		random() % ((NSUInteger)((CGRectGetHeight(self.view.bounds) / 20.0) - 3) + 2)
	};
	
	mecoView.center = (CGPoint){
		(tile.x * 20) + 10,
		(tile.y * 20) + 20
	};
	
	mecoView.behaviours = @[[MECOGravity new], [MECOWanderingBehaviour new]];
	
	[self.sprites addObject:mecoView];
	
	person.sprite = mecoView;
	mecoView.actor = person;
	
	[mecoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMeco:)]];
	
	[self.view addSubview:mecoView];
	
	person.delegate = self;
}

-(void)addSpriteForHouse:(MECOHouse *)house {
	MECOSpriteView *houseView = [MECOSpriteView spriteWithImage:[UIImage imageNamed:@"MecoHut.png"]];
	houseView.delegate = self;
	houseView.behaviours = @[[MECOGravity new]];
	CGSize size = houseView.bounds.size;
	houseView.center = (CGPoint){ house.location.x + size.width / 2, size.height / 2 };
	
	house.sprite = houseView;
	houseView.actor = house;
	
	[self.sprites addObject:houseView];
	
	[self.view insertSubview:houseView aboveSubview:self.groundView];
}


#pragma mark MECOIslandDelegate

-(void)island:(MECOIsland *)island didAddPerson:(MECOPerson *)person {
	[self addSpriteForPerson:person];
}

-(void)island:(MECOIsland *)island didAddHouse:(MECOHouse *)house {
	[self addSpriteForHouse:house];
}

#pragma mark MECOPersonDelegate

-(void)person:(MECOPerson *)person didStartJob:(MECOJob *)job {
	MECOSpriteView *spriteView = person.sprite;
	spriteView.image = job.costumeImage;
}

#pragma mark MECOActor

-(void)gameController:(MECOGameController *)gameController updateWithInterval:(NSTimeInterval)interval {
	for (MECOSpriteView *sprite in self.sprites) {
		[sprite updateWithInterval:interval];
	}
}

@end
