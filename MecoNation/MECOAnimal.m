//
//  MECOAnimal.m
//  MecoNation
//
//  Created by Micah Merswolke on 2013-09-01.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOWorld.h"
#import "MECOAnimal.h"

@implementation MECOAnimal

-(NSUInteger) resourcesGiven {
	return 0;
}

+(NSArray *)animalsWithWorld:(MECOWorld *)world {
	static NSArray *allAnimals = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableArray *animals = [NSMutableArray new];
		for (NSDictionary *animalDictionary in [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Spawnables" ofType:@"plist"]]) {
			NSString *name = animalDictionary[@"name"];
			NSString *imageName = animalDictionary[@"graphic"];
			UIImage *image = imageName? [UIImage imageNamed:imageName] : nil;
			MECOResource *resourceGiven = animalDictionary[@"resourceGiven"];
			MECOResource *rareResourceGiven = animalDictionary[@"rareResourceGiven"];
			float resourceAmount = [animalDictionary[@"resourceAmount"] floatValue];
			float IQCost = [animalDictionary[@"IQCost"] floatValue];
			
			[animals addObject:[MECOAnimal animalWithName:name image:image resourceGiven:resourceGiven rareResourceGiven:rareResourceGiven resourceAmount:resourceAmount]];
		}
		allAnimals = animals;
	});
	return allAnimals;
}

@end

