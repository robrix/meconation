//
//  MECOViewController.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MECOIsland, MECOJob;
@class MECOWorldViewController;

@interface MECOIslandViewController : UIViewController

@property (nonatomic, strong) MECOIsland *island;
@property (nonatomic) NSUInteger islandIndex;
@property (weak) MECOWorldViewController *worldViewController;


-(void)addMecoWithJob:(MECOJob *)job;
-(IBAction)showSpawnMenu:(id)sender;

-(IBAction)addMeco:(id)sender;
-(IBAction)showJobsMenu:(id)sender;

@end
