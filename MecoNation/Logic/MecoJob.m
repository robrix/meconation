//  MecoJob.m
//  Created by Rob Rix on 11-12-30.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import "MecoJob.h"

@implementation MecoJob

+(MecoJob *)job {
	return [self new];
}


-(NSString *)title {
	return nil;
}


-(void)encodeWithCoder:(NSCoder *)encoder {
	
}

-(id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		
	}
	return self;
}

@end
