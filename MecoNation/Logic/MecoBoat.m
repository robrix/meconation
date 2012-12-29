//  MecoBoat.m
//  Created by Rob Rix on 11-12-30.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import "MecoBoat.h"

@implementation MecoBoat

+(MecoBoat *)boat {
	return [self new];
}


-(NSUInteger)cost {
	return 60;
}

-(NSString *)label {
	return @"boat";
}

@end
