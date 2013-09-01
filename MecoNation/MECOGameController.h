//
//  MECOGameController.h
//  MecoNation
//
//  Created by Rob Rix on 8/31/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOActor.h"

@class MECOWorld;

@interface MECOGameController : NSObject

@property (nonatomic) MECOWorld *world;

@property (nonatomic, copy) NSSet *actors;
-(void)addActorsObject:(id<MECOActor>)actor;
-(void)removeActorsObject:(id<MECOActor>)actor;

@property (nonatomic, getter = isPaused) bool paused;

@end
