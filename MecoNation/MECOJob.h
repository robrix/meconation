//
//  MECOJob.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MECOJobResponsibility.h"

extern NSString * const MECOScientistJobTitle;
extern NSString * const MECOTailorJobTitle;
extern NSString * const MECOWorkerJobTitle;
extern NSString * const MECOFarmerJobTitle;
extern NSString * const MECOUnemployedJobTitle;

@class MECOPerson;

@interface MECOJob : NSObject

+(NSArray *)jobsWithWorld:(id<MECOWorld>)world;
+(MECOJob *)jobWithTitle:(NSString *)title costumeImage:(UIImage *)costumeImage responsibility:(id<MECOJobResponsibility>)responsibility;

@property (strong, readonly) NSString *title;
@property (strong, readonly) UIImage *costumeImage;
@property (strong, readonly) id<MECOJobResponsibility> responsibility;

-(void)personWillQuit:(MECOPerson *)person;
-(void)personDidStart:(MECOPerson *)person;

@end
