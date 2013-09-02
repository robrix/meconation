//  MECOJobResponsibility.h
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOWorld.h"
#import "MECOActor.h"

@class MECOPerson, MECOResourceRate;

@protocol MECOJobResponsibility <NSObject, NSCopying, MECOActor>

+(instancetype)responsibilityWithDictionary:(NSDictionary *)dictionary world:(MECOWorld *)world;

-(void)personWillQuit:(MECOPerson *)person;
-(void)personDidStart:(MECOPerson *)person;

@end

@interface MECOEarningJobResponsibility : NSObject <MECOJobResponsibility>

+(instancetype)responsibilityWithRate:(MECOResourceRate *)rate;

@end
