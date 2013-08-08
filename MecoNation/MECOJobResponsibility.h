//  MECOJobResponsibility.h
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOWorld.h"

@class MECOPerson;

@protocol MECOJobResponsibility <NSObject>

+(instancetype)responsibilityWithWorld:(id<MECOWorld>)world;

@property (strong, readonly) id<MECOWorld> world;

-(void)personWillQuit:(MECOPerson *)person;
-(void)personDidStart:(MECOPerson *)person;

@end


@interface MECOScientistJobResponsibility : NSObject <MECOJobResponsibility>
@property (readonly) float rate;
@end

@interface MECOMadScientistJobResponsibility : MECOScientistJobResponsibility
@end


@interface MECOLumberjackJobResponsibility : NSObject <MECOJobResponsibility>
@property (readonly) float rate;
@end

@interface MECOMinerJobResponsibility : NSObject <MECOJobResponsibility>
@property (readonly) float rate;
@end

@interface MECOFishermanJobResponsibility : NSObject <MECOJobResponsibility>
@property (readonly) float rate;
@end
