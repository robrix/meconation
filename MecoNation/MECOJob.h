//
//  MECOJob.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOSaleItem.h"
#import "MECOJobResponsibility.h"

extern NSString * const MECOScientistJobTitle;
extern NSString * const MECOTailorJobTitle;
extern NSString * const MECOWorkerJobTitle;
extern NSString * const MECOFarmerJobTitle;
extern NSString * const MECOExplorerJobTitle;
extern NSString * const MECOLumberjackJobTitle;
extern NSString * const MECOMinerJobTitle;
extern NSString * const MECOBlacksmithJobTitle;
extern NSString * const MECOWeathermanJobTitle;
extern NSString * const MECOBodyguardJobTitle;
extern NSString * const MECOFishermanJobTitle;
extern NSString * const MECOSoldierJobTitle;
extern NSString * const MECODoctorJobTitle;
extern NSString * const MECOTeacherJobTitle;
extern NSString * const MECOTraderJobTitle;
extern NSString * const MECOUnemployedJobTitle;

@class MECOPerson;

@interface MECOJob : NSObject <NSCopying, MECOSaleItem>

+(NSArray *)jobsWithWorld:(MECOWorld *)world;
+(MECOJob *)jobWithTitle:(NSString *)title costumeImage:(UIImage *)costumeImage responsibilities:(NSArray *)responsibilities costs:(NSArray *)costs;

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) UIImage *costumeImage;
@property (nonatomic, copy, readonly) NSArray *responsibilities;
@property (nonatomic, copy, readonly) NSArray *costs;

-(void)personWillQuit:(MECOPerson *)person;
-(void)personDidStart:(MECOPerson *)person;

@end
