//
//  MECOAnimal.m
//  MecoNation
//
//  Created by Micah Merswolke on 2013-09-01.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOWorld.h"
#import "MECOAnimal.h"
#import "MECOResource.h"

@interface MECOAnimal ()

@property (nonatomic, copy) NSArray *costs;

@end

@implementation MECOAnimal

@synthesize sprite = _sprite;

+(NSArray *)animalsWithWorld:(MECOWorld *)world {
	static NSArray *allAnimals = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableArray *animals = [NSMutableArray new];
		for (NSDictionary *animalDictionary in [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Spawnables" ofType:@"plist"]]) {
			NSString *name = animalDictionary[@"name"];
			NSString *imageName = animalDictionary[@"graphic"];
			UIImage *image = imageName? [UIImage imageNamed:imageName] : nil;
			MECOResource *resourceGiven = world.resourcesByName[animalDictionary[@"resourceGiven"]];
			MECOResource *rareResourceGiven = world.resourcesByName[animalDictionary[@"rareResourceGiven"]];
			float resourceAmount = [animalDictionary[@"resourceAmount"] floatValue];
			MECOResourceCost *cost = [MECOResourceCost costWithResource:world.resourcesByName[@"IQ"] quantity:[animalDictionary[@"IQCost"] floatValue]];
			
			[animals addObject:[MECOAnimal animalWithName:name image:image resourceGiven:resourceGiven rareResourceGiven:rareResourceGiven resourceAmount:resourceAmount costs:@[cost]]];
		}
		allAnimals = animals;
	});
	return allAnimals;
}

+(MECOAnimal *)animalWithName:(NSString *)name image:(UIImage *)image resourceGiven:(MECOResource *)resourceGiven rareResourceGiven:(MECOResource *)rareResourceGiven  resourceAmount:(float)resourceAmount costs:(NSArray *)costs {
	MECOAnimal *animals = [self new];
	animals.name = name;
	animals.image = image;
	animals.resourceGiven = resourceGiven;
	animals.rareResourceGiven = rareResourceGiven;
	animals.resourceAmount = resourceAmount;
	animals.costs = costs;
	return animals;
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	MECOAnimal *animal = [self.class new];
	animal.name = self.name;
	animal.image = self.image;
	animal.resourceGiven = self.resourceGiven;
	animal.rareResourceGiven = self.rareResourceGiven;
	animal.resourceAmount = self.resourceAmount;
	animal.costs = self.costs;
	return animal;
}

@end

