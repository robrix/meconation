//
//  MECOViewController.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOIslandViewController.h"
#import "MECOSpriteView.h"
#import "MECOSpriteBehaviour.h"
#import "MECOWorldViewController.h"
#import "MECOViewUtilities.h"

#import "MECOAnimal.h"
#import "MECOGroundView.h"
#import "MECOHouse.h"
#import "MECOIsland.h"
#import "MECOJob.h"
#import "MECOPerson.h"

#import "RXOptionSheet.h"

#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>

@interface MECOIslandViewController () <MECOSpriteViewDelegate, UIActionSheetDelegate, MECOIslandDelegate>

@property (strong) MECOGroundView *groundView;

@property (strong) NSMutableSet *sprites;

@property (readonly) CGRect validBoundsForMecos;

@property (nonatomic) id didStartJobObserver;

@end

#define MECOConstrainValueToRange(value, minimum, maximum) \
	MAX(MIN((value), (maximum)), (minimum))

@implementation MECOIslandViewController

-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self.didStartJobObserver];
}

@synthesize island = _island;
@synthesize islandIndex = _islandIndex;
@synthesize groundView = _groundView;
@synthesize sprites = _sprites;

-(void)configureWithIslandAtIndex:(NSUInteger)index inWorld:(MECOWorld *)world {
	self.didStartJobObserver = [[NSNotificationCenter defaultCenter] addObserverForName:MECOPersonDidStartJobNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		MECOPerson *person = note.object;
		MECOSpriteView *spriteView = person.sprite;
		spriteView.image = [self imageForPerson:person];
	}];
	
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
		
		MECOPerson *meco = view.model;
		
		[self.view bringSubviewToFront:view];
		
		UILabel *info = [UILabel new];
		info.text = [NSString stringWithFormat:@"%@ (%@)", meco.name, meco.job.title ?: @"Unemployed"];
		info.backgroundColor = [UIColor clearColor];
		info.textColor = [UIColor blackColor];
		info.textAlignment = NSTextAlignmentCenter;
		[info sizeToFit];
		info.center = (CGPoint){
			CGRectGetMidX(view.bounds),
			-(CGRectGetHeight(info.bounds) + 2)
		};
		MECOFadeInView(info, view);
		MECOFadeOutView(info, 3);
	}
}

-(UIImage *)imageForPerson:(MECOPerson *)person {
	return person.job.costumeImage ?: [UIImage imageNamed:@"Meco.png"];
}

-(MECOSpriteView *)addSpriteWithImage:(UIImage *)image model:(id<MECOSpriteModel>)model {
	MECOSpriteView *spriteView = [MECOSpriteView spriteWithImage:image];
	spriteView.delegate = self;
	
	spriteView.model = model;
	model.sprite = spriteView;
	
	[self.sprites addObject:spriteView];
	
	return spriteView;
}

-(void)removeSpriteForModel:(id<MECOSpriteModel>)model {
	[model.sprite removeFromSuperview];
}


-(CGPoint)randomTileLocationForSprite:(MECOSpriteView *)sprite {
	CGPoint tile = (CGPoint){
		random() % (NSUInteger)(CGRectGetWidth(self.view.bounds) / 20.0),
		random() % ((NSUInteger)((CGRectGetHeight(self.view.bounds) / 20.0) - 3) + 2)
	};
	return (CGPoint){
		(tile.x * [MECOIsland gridSize].width) + (sprite.bounds.size.width / 2.0),
		(tile.y * [MECOIsland gridSize].height) + (sprite.bounds.size.height / 2.0)
	};
}

-(void)addSpriteForPerson:(MECOPerson *)person {
	MECOSpriteView *sprite = [self addSpriteWithImage:[self imageForPerson:person] model:person];
	sprite.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
	
	sprite.center = [self randomTileLocationForSprite:sprite];
	
	sprite.behaviours = @[[MECOGravity new], [MECOWanderingBehaviour new]];
	
	[sprite addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMeco:)]];
	
	[self.view addSubview:sprite];
}

-(void)addSpriteForHouse:(MECOHouse *)house {
	MECOSpriteView *sprite = [self addSpriteWithImage:[UIImage imageNamed:@"MecoHut.png"] model:house];
	sprite.behaviours = @[[MECOGravity new]];
	CGSize size = sprite.bounds.size;
	sprite.center = (CGPoint){ house.location.x + size.width / 2, size.height / 2 };
	
	[self.view insertSubview:sprite aboveSubview:self.groundView];
}

-(void)addSpriteForAnimal:(MECOAnimal *)animal {
	MECOSpriteView *sprite = [self addSpriteWithImage:animal.image model:animal];
	
	sprite.behaviours = @[[MECOGravity new], [MECOWanderingBehaviour new]];
	
	sprite.center = [self randomTileLocationForSprite:sprite];
	
	[self.view addSubview:sprite];
}


#pragma mark MECOIslandDelegate

-(void)island:(MECOIsland *)island didAddAnimal:(MECOAnimal *)animal {
	[self addSpriteForAnimal:animal];
}

-(void)island:(MECOIsland *)island willRemoveAnimal:(MECOAnimal *)animal {
	[self removeSpriteForModel:animal];
}


-(void)island:(MECOIsland *)island didAddPerson:(MECOPerson *)person {
	[self addSpriteForPerson:person];
}

-(void)island:(MECOIsland *)island willRemovePerson:(MECOPerson *)person {
	[self removeSpriteForModel:person];
}


-(void)island:(MECOIsland *)island didAddHouse:(MECOHouse *)house {
	[self addSpriteForHouse:house];
}


#pragma mark MECOActor

-(void)gameController:(MECOGameController *)gameController updateWithInterval:(NSTimeInterval)interval {
	for (MECOSpriteView *sprite in self.sprites) {
		[sprite updateWithInterval:interval];
	}
}

@end
