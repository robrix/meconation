//
//  MECOPerson.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MECOJob;

@interface MECOPerson : NSObject

+(NSString *)randomName;
+(MECOPerson *)personWithName:(NSString *)name job:(MECOJob *)job;

@property (copy, readonly) NSString *name;
@property (nonatomic, strong) MECOJob *job;

@property (readonly) NSString *label;

@property (weak) id sprite;

@end

extern NSString * const MECOPersonWillQuitJobNotification;
extern NSString * const MECOPersonDidStartJobNotification;
