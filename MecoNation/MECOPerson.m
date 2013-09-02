//
//  MECOPerson.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOJob.h"
#import "MECOPerson.h"
#import <stdlib.h>

@interface MECOPerson ()

@property (copy, readwrite) NSString *name;

@end

@implementation MECOPerson

+(void)initialize {
	srandomdev();
}

@synthesize name = _name;
@synthesize job = _job;
@synthesize sprite = _sprite;

+(NSArray *)firstNames {
	return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FirstNames" ofType:@"plist"]];
}

+(NSArray *)lastNames {
	return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LastNames" ofType:@"plist"]];
}

+(NSString *)randomName {
	NSArray *firstNames = [self firstNames];
	NSArray *lastNames = [self lastNames];
	return [NSString stringWithFormat:@"%@ %@", [firstNames objectAtIndex:random() % firstNames.count], [lastNames objectAtIndex:random() % lastNames.count]];
}

+(MECOPerson *)personWithName:(NSString *)name job:(MECOJob *)job {
	MECOPerson *person = [self new];
	person.name = name;
	person.job = job;
	return person;
}


-(NSString *)label {
	return [NSString stringWithFormat:@"%@ (%@)", self.name, self.job.title ?: @"Unemployed"];
}


-(void)setJob:(MECOJob *)job {
	if (![self.job isEqual:job]) {
		[self.job personWillQuit:self];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:MECOPersonWillQuitJobNotification object:self];
		
		
		_job = job;
		
		[self.job personDidStart:self];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:MECOPersonDidStartJobNotification object:self];
	}
}

@end

NSString * const MECOPersonWillQuitJobNotification = @"MECOPersonWillQuitJobNotification";
NSString * const MECOPersonDidStartJobNotification = @"MECOPersonDidStartJobNotification";
