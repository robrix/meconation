//
//  MECOJob.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOJob.h"

@interface MECOJob ()

@property (strong, readwrite) NSString *title;
@property (strong, readwrite) UIImage *costumeImage;

@end

@implementation MECOJob

@synthesize title = _title;
@synthesize costumeImage = _costumeImage;

+(NSArray *)allJobs {
	NSMutableArray *allJobs = [NSMutableArray new];
	for (NSDictionary *jobDictionary in [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Jobs" ofType:@"plist"]]) {
		NSString *title = [jobDictionary objectForKey:@"title"];
		NSString *costumeImageName = [jobDictionary objectForKey:@"costumeImage"];
		UIImage *costumeImage = costumeImageName? [UIImage imageNamed:costumeImageName] : nil;
		[allJobs addObject:[MECOJob jobWithTitle:title costumeImage:costumeImage]];
	}
	return allJobs;
}

+(MECOJob *)jobWithTitle:(NSString *)title costumeImage:(UIImage *)costumeImage {
	MECOJob *job = [self new];
	job.title = title;
	job.costumeImage = costumeImage;
	return job;
}

@end
