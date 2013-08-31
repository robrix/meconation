//
//  MECOWorldController.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-31.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MECOWorld.h"

@interface MECOWorldViewController : UIViewController <MECOWorld>

-(void) updatePopulationLabel;
-(void) updateWarningLabelForSheep;
-(void) updateWarningLabelForPopulation;
-(NSUInteger) maximumPopulation;
-(NSUInteger) mecoPopulation;

@end
