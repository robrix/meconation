//
//  MECOWorld.h
//  MecoNation
//
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOActor.h"

@class MECOResource;

@interface MECOWorld : NSObject

#pragma mark Resources

@property (nonatomic, readonly) MECOResource *foodResource;
@property (nonatomic, readonly) MECOResource *leafResource;
@property (nonatomic, readonly) MECOResource *leatherResource;
@property (nonatomic, readonly) MECOResource *goldResource;
@property (nonatomic, readonly) MECOResource *furResource;
@property (nonatomic, readonly) MECOResource *IQResource;
@property (nonatomic, readonly) MECOResource *stoneResource;
@property (nonatomic, readonly) MECOResource *woodResource;
@property (nonatomic, readonly) MECOResource *woolResource;

@property (nonatomic, readonly) NSArray *resources;
@property (nonatomic, readonly) NSDictionary *resourcesByName;

#pragma mark Jobs

@property (nonatomic, readonly) NSArray *jobs;
@property (nonatomic, readonly) NSDictionary *jobsByTitle;

#pragma mark Spawnables

@property (nonatomic, readonly) NSArray *spawnables;
@property (nonatomic, readonly) NSDictionary *spawnablesByName;

#pragma mark Islands

@property (nonatomic, readonly) NSArray *islands;

@property (nonatomic, readonly) NSSet *allMecos;
@property (nonatomic, readonly) NSSet *allHouses;

@property (nonatomic, readonly) NSUInteger currentPopulation;
@property (nonatomic, readonly) NSUInteger maximumPopulation;

@end
