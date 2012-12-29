//  MecoSheep.m
//  Created by Rob Rix on 11-12-30.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import "MecoSheep.h"

@implementation MecoSheep

+(MecoSheep *)sheep {
	return [self new];
}

//what does a sheep cost?
-(NSUInteger)cost {
	return 20;
}
//what does the computer call 'sheep'?
-(NSString *)label {
	return @"sheep";
}

@end
