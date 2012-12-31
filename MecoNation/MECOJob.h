//
//  MECOJob.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MECOScientistJobTitle;
extern NSString * const MECOTailorJobTitle;
extern NSString * const MECOWorkerJobTitle;
extern NSString * const MECOFarmerJobTitle;

@interface MECOJob : NSObject

+(NSArray *)allJobs;
+(MECOJob *)jobTitled:(NSString *)title;

+(MECOJob *)jobWithTitle:(NSString *)title costumeImage:(UIImage *)costumeImage;

@property (strong, readonly) NSString *title;
@property (strong, readonly) UIImage *costumeImage;

@end
