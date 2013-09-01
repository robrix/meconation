//
//  MECOWorldController.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-31.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MECOWorld.h"

@interface MECOWorldViewController : UIViewController

@property (nonatomic) MECOWorld *world;

-(void) updatePopulationLabel;
-(void) updateWarningLabelForSheep;
-(void) updateWarningLabelForPopulation;

-(IBAction)showBoatWarning:(id)sender;
-(IBAction)showBuildMenu:(id)sender;
-(IBAction)showSpawnMenu:(id)sender;
-(IBAction)spawnMeco:(id)sender;
-(IBAction)addMeco:(id)sender;
-(IBAction)showJobsMenu:(id)sender;
-(IBAction)showFireMenu:(id)sender;

@end
