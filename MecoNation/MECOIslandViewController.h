//
//  MECOViewController.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MECOIsland, MECOJob, MECOWorld;
@class MECOWorldViewController;

@interface MECOIslandViewController : UIViewController

-(void)configureWithIslandAtIndex:(NSUInteger)index inWorld:(MECOWorld *)world;

@property (nonatomic, readonly) MECOWorld *world;
@property (nonatomic, readonly) MECOIsland *island;
@property (nonatomic, readonly) NSUInteger islandIndex;

@property (weak) MECOWorldViewController *worldViewController;

@end
