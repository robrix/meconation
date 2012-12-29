//  MecoIsland.m
//  Created by Hac!m on 11-12-29.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import "MecoIsland.h"

@implementation MecoIsland

@synthesize maximumHouseCount, houseCount, population, mecaPopulation, meciPopulation;


+(MecoIsland *)islandWithMaximumHouseCount:(NSUInteger)maximumHouseCount
								houseCount:(NSUInteger)houseCount
								population:(NSUInteger)population
							mecaPopulation:(NSUInteger)mecaPopulation
							meciPopulation:(NSUInteger)meciPopulation {
	MecoIsland *island = [self new];
	island->maximumHouseCount = maximumHouseCount;
	island->houseCount = houseCount;
	island->population = population;
	island->mecaPopulation = mecaPopulation;
	island->meciPopulation = meciPopulation;
	return island;
}


-(NSUInteger) maximumPopulation{
	return houseCount*4-1;
}


-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInteger:maximumHouseCount forKey:@"maximumHouseCount"];
	[encoder encodeInteger:houseCount forKey:@"houseCount"];
	[encoder encodeInteger:population forKey:@"population"];
	[encoder encodeInteger:mecaPopulation forKey:@"mecaPopulation"];
	[encoder encodeInteger:meciPopulation forKey:@"meciPopulation"];
}

-(id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		maximumHouseCount = [decoder decodeIntegerForKey:@"maximumHouseCount"];
		houseCount = [decoder decodeIntegerForKey:@"houseCount"];
		population = [decoder decodeIntegerForKey:@"population"];
		mecaPopulation = [decoder decodeIntegerForKey:@"mecaPopulation"];
		meciPopulation = [decoder decodeIntegerForKey:@"meciPopulation"];
	}
	return self;
}

@end
