//
//  MECOViewController.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MECOIsland;

@interface MECOViewController : UIViewController

@property (nonatomic, strong) MECOIsland *island;
@property (nonatomic) NSUInteger islandIndex;

@end
