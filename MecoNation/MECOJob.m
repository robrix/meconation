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
NSString * const MECOMinerJobTitle = @"Miner";
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
@property (strong, readwrite) NSArray *responsibilities;

@end

@implementation MECOJob

@synthesize title = _title;
@synthesize costumeImage = _costumeImage;

+(NSArray *)jobsWithWorld:(MECOWorld *)world {
	static NSArray *allJobs = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableArray *jobs = [NSMutableArray new];
		for (NSDictionary *jobDictionary in [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Jobs" ofType:@"plist"]]) {
			NSString *title = jobDictionary[@"title"];
			NSString *costumeImageName = jobDictionary[@"costumeImage"];
			UIImage *costumeImage = costumeImageName? [UIImage imageNamed:costumeImageName] : nil;
			
			NSMutableArray *responsibilities = [NSMutableArray new];
			for (NSDictionary *responsibilityDictionary in jobDictionary[@"responsibilities"]) {
				NSString *className = responsibilityDictionary[@"class"];
				id<MECOJobResponsibility> responsibility = [NSClassFromString(className) responsibilityWithDictionary:responsibilityDictionary world:world];
				[responsibilities addObject:responsibility];
			}
			
			[jobs addObject:[MECOJob jobWithTitle:title costumeImage:costumeImage responsibilities:responsibilities]];
		}
		allJobs = jobs;
	});
	return allJobs;
}

+(MECOJob *)jobWithTitle:(NSString *)title costumeImage:(UIImage *)costumeImage responsibilities:(NSArray *)responsibilities {
	MECOJob *job = [self new];
	job.title = title;
	job.costumeImage = costumeImage;
	job.responsibilities = responsibilities;
	return job;
}


-(void)personWillQuit:(MECOPerson *)person {
	for (id<MECOJobResponsibility> responsibility in self.responsibilities) {
		[responsibility personWillQuit:person];
	}
}

-(void)personDidStart:(MECOPerson *)person {
	for (id<MECOJobResponsibility> responsibility in self.responsibilities) {
		[responsibility personDidStart:person];
	}
}


#pragma mark NSObject

-(bool)isEqualToJob:(MECOJob *)other {
	return [self.title isEqualToString:other.title];
}

-(BOOL)isEqual:(id)object {
	return
		[object isKindOfClass:[MECOJob class]]
	&&	[self isEqualToJob:object];
}

@end
