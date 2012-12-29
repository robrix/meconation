//  MecoPerson.h
//  Created by Rob Rix on 11-12-29.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import "MecoItem.h"

@class MecoJob;

@interface MecoPerson : MecoItem {
	NSString *name;
	MecoJob *job;
}

+(MecoPerson *)personWithJob:(MecoJob *)job;

@property (readonly) NSString *name;
@property (readonly) MecoJob *job;

@end
