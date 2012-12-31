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

@interface MECOJob ()

@property (strong, readwrite) NSString *title;
@property (strong, readwrite) UIImage *costumeImage;

@end

@implementation MECOJob

@synthesize title = _title;
@synthesize costumeImage = _costumeImage;

+(NSDictionary *)allJobsByTitle {
	static NSDictionary *allJobsByTitle = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		allJobsByTitle = [NSDictionary dictionaryWithObjects:[self allJobs] forKeys:[[self allJobs] valueForKey:@"title"]];
	});
	return allJobsByTitle;
}

+(MECOJob *)jobTitled:(NSString *)title {
	return [[self allJobsByTitle] objectForKey:title];
}

+(NSArray *)allJobs {
	static NSArray *allJobs = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableArray *jobs = [NSMutableArray new];
		for (NSDictionary *jobDictionary in [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Jobs" ofType:@"plist"]]) {
			NSString *title = [jobDictionary objectForKey:@"title"];
			NSString *costumeImageName = [jobDictionary objectForKey:@"costumeImage"];
			UIImage *costumeImage = costumeImageName? [UIImage imageNamed:costumeImageName] : nil;
			[jobs addObject:[MECOJob jobWithTitle:title costumeImage:costumeImage]];
		}
		allJobs = jobs;
	});
	return allJobs;
}

+(MECOJob *)jobWithTitle:(NSString *)title costumeImage:(UIImage *)costumeImage {
	MECOJob *job = [self new];
	job.title = title;
	job.costumeImage = costumeImage;
	return job;
}

@end
