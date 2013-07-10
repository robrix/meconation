//
//  MECOJob.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOJob.h"

NSString * const MECOScientistJobTitle = @"Scientist";
NSString * const MECOTailorJobTitle = @"Tailor";
NSString * const MECOWorkerJobTitle = @"Worker";
NSString * const MECOFarmerJobTitle = @"Farmer";
NSString * const MECOExplorerJobTitle = @"Explorer";
NSString * const MECOLumberjackJobTitle = @"Lumberjack";
NSString * const MECOMinerTitle = @"Miner";
NSString * const MECOBlacksmithJobTitle = @"Blacksmith";
NSString * const MECOWeathermanJobTitle = @"Weatherman";
NSString * const MECOBodyguardJobTitle = @"Bodyguard";
NSString * const MECOFishermanJobTitle = @"Fisherman";
NSString * const MECOSoldierJobTitle = @"Soldier";
NSString * const MECODoctorJobTitle = @"Doctor";
NSString * const MECOTeacherJobTitle = @"Teacher";
NSString * const MECOTraderJobTitle = @"Trader";
NSString * const MECOUnemployedJobTitle = @"Unemployed";

@interface MECOJob ()

@property (strong, readwrite) NSString *title;
@property (strong, readwrite) UIImage *costumeImage;
@property (strong, readwrite) id<MECOJobResponsibility> responsibility;

@end

@implementation MECOJob

@synthesize title = _title;
@synthesize costumeImage = _costumeImage;

+(NSArray *)jobsWithWorld:(id<MECOWorld>)world {
	static NSArray *allJobs = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableArray *jobs = [NSMutableArray new];
		for (NSDictionary *jobDictionary in [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Jobs" ofType:@"plist"]]) {
			NSString *title = jobDictionary[@"title"];
			NSString *costumeImageName = jobDictionary[@"costumeImage"];
			UIImage *costumeImage = costumeImageName? [UIImage imageNamed:costumeImageName] : nil;
			NSString *responsibilityClassName = jobDictionary[@"responsibilityClass"];
			[jobs addObject:[MECOJob jobWithTitle:title costumeImage:costumeImage responsibility:[NSClassFromString(responsibilityClassName) responsibilityWithWorld:world]]];
		}
		allJobs = jobs;
	});
	return allJobs;
}

+(MECOJob *)jobWithTitle:(NSString *)title costumeImage:(UIImage *)costumeImage responsibility:(id<MECOJobResponsibility>)responsibility {
	MECOJob *job = [self new];
	job.title = title;
	job.costumeImage = costumeImage;
	job.responsibility = responsibility;
	return job;
}


-(void)personWillQuit:(MECOPerson *)person {
	[self.responsibility personWillQuit:person];
}

-(void)personDidStart:(MECOPerson *)person {
	[self.responsibility personDidStart:person];
}

@end
