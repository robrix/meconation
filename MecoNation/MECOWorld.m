//
//  MECOWorld.m
//  MecoNation
//
//  Created by Rob Rix on 8/31/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOHouse.h"
#import "MECOIsland.h"
#import "MECOJob.h"
#import "MECOPerson.h"
#import "MECOResource.h"
#import "MECOWorld.h"

@implementation MECOWorld

-(instancetype)init {
	if ((self = [super init])) {
		_foodResource = [MECOResource resourceWithName:@"food"];
		_leafResource = [MECOResource resourceWithName:@"leaf"];
		_leatherResource = [MECOResource resourceWithName:@"leather"];
		_goldResource = [MECOResource resourceWithName:@"gold"];
		_furResource = [MECOResource resourceWithName:@"fur"];
		_IQResource = [MECOResource resourceWithName:@"IQ"];
		_stoneResource = [MECOResource resourceWithName:@"stone"];
		_woodResource = [MECOResource resourceWithName:@"wood"];
		_woolResource = [MECOResource resourceWithName:@"wool"];
		
		_resources = @[_foodResource, _leafResource, _leatherResource, _goldResource, _furResource, _IQResource, _stoneResource, _woodResource, _woolResource];
		
		_jobs = [[MECOJob jobsWithWorld:self] copy];
		_jobsByTitle = [[NSDictionary dictionaryWithObjects:self.jobs forKeys:[self.jobs valueForKey:@"title"]] copy];
		
		_islands = [MECOIsland allIslands];
		
		for (MECOIsland *island in _islands) {
			for (NSValue *value in island.houseLocations) {
				MECOHouse *house = [MECOHouse houseWithLocation:value.CGPointValue];
				[island addHouse:house];
			}
		}
		
		MECOIsland *firstIsland = _islands[0];
		MECOPerson *scientist = [MECOPerson personWithName:[MECOPerson randomName] job:self.jobsByTitle[MECOScientistJobTitle]];
		MECOPerson *farmer = [MECOPerson personWithName:[MECOPerson randomName] job:self.jobsByTitle[MECOFarmerJobTitle]];
		MECOPerson *tailor = [MECOPerson personWithName:[MECOPerson randomName] job:self.jobsByTitle[MECOTailorJobTitle]];
		[firstIsland addPerson:scientist];
		[firstIsland addPerson:farmer];
		[firstIsland addPerson:tailor];
	}
	return self;
}


-(NSSet *)allMecos {
	NSMutableSet *mecos = [NSMutableSet new];
	for (MECOIsland *island in self.islands) {
		[mecos unionSet:island.mecos];
	}
	return mecos;
}

-(NSSet *)allHouses {
	NSMutableSet *houses = [NSMutableSet new];
	for (MECOIsland *island in self.islands) {
		[houses unionSet:island.houses];
	}
	return houses;
}


-(NSUInteger)currentPopulation {
	return self.allMecos.count;
}

-(NSUInteger)maximumPopulation {
	return self.allHouses.count * 4 - 1;
}
@end
