//
//  MECOActor.h
//  MecoNation
//
//  Created by Rob Rix on 9/1/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MECOGameController;

@protocol MECOActor <NSObject>

-(void)gameController:(MECOGameController *)gameController updateWithInterval:(NSTimeInterval)interval;

@optional

-(void)gameControllerDidPause:(MECOGameController *)gameController;
-(void)gameControllerDidResume:(MECOGameController *)gameController;

@end
