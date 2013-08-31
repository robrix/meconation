//
//  MECOGameController.h
//  MecoNation
//
//  Created by Rob Rix on 8/31/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MECOWorld;
@protocol MECOActor;

@interface MECOGameController : NSObject

-(instancetype)initWithWorld:(MECOWorld *)world;

@property (nonatomic, readonly) MECOWorld *world;

@property (nonatomic, copy) NSSet *actors;
-(void)addActorsObject:(id<MECOActor>)actor;
-(void)removeActorsObject:(id<MECOActor>)actor;

@property (nonatomic, getter = isPaused) bool paused;

@end


@protocol MECOActor <NSObject>

-(void)gameController:(MECOGameController *)gameController updateWithInterval:(NSTimeInterval)interval;

@optional

-(void)gameControllerDidPause:(MECOGameController *)gameController;
-(void)gameControllerDidResume:(MECOGameController *)gameController;

@end
