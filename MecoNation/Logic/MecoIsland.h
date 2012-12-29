//  MecoIsland.h
//  Created by Hac!m on 11-12-29.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface MecoIsland : NSObject <NSCoding> {
	NSUInteger maximumHouseCount;
	NSUInteger houseCount;
	NSUInteger population;
	NSUInteger mecaPopulation;
	NSUInteger meciPopulation;
	
}

+(MecoIsland *)islandWithMaximumHouseCount:(NSUInteger)maximumHouseCount
								houseCount:(NSUInteger)houseCount
								population:(NSUInteger)population
							mecaPopulation:(NSUInteger)mecaPopulation
							meciPopulation:(NSUInteger)meciPopulation;

@property (readonly) NSUInteger maximumHouseCount;
@property (assign) NSUInteger houseCount;
@property (readonly) NSUInteger population;
@property (readonly) NSUInteger mecaPopulation;
@property (readonly) NSUInteger meciPopulation;
@property (readonly) NSUInteger maximumPopulation;

@end
