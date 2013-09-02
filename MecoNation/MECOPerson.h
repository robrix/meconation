//
//  MECOPerson.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOSpriteModel.h"

@class MECOJob;

@interface MECOPerson : NSObject <MECOSpriteModel>

+(NSString *)randomName;
+(MECOPerson *)personWithName:(NSString *)name job:(MECOJob *)job;

@property (copy, readonly) NSString *name;
@property (nonatomic, copy) MECOJob *job;

@property (readonly) NSString *label;

@end

extern NSString * const MECOPersonWillQuitJobNotification;
extern NSString * const MECOPersonDidStartJobNotification;
