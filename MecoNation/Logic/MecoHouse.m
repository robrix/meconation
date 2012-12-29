//  MecoHouse.m
//  Created by Rob Rix on 11-12-30.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import "MecoHouse.h"
#import "MecoWorld.h"
#import "MecoIsland.h"

@implementation MecoHouse

+(MecoHouse *)house {
	return [self new];
}

-(void)purchaseWithWorld:(MecoWorld *)world {
	[super purchaseWithWorld:world];
	world.currentIsland.houseCount+= 1;
}

-(NSUInteger)cost {
	return 50;
}

-(NSString *)label {
	return @"house";
}

-(BOOL)canPurchaseWithWorld:(MecoWorld *)world {
	return
	[super canPurchaseWithWorld:world]
	&&	(world.currentIsland.houseCount < world.currentIsland.maximumHouseCount);
}

-(NSString *)messageForPurchaseWithWorld:(MecoWorld *)world {
	NSString *message = nil;
	if(world.currentIsland.houseCount >= world.currentIsland.maximumHouseCount)
		message = [NSString stringWithFormat:@"Not enough room on island %u for another house", world.indexOfCurrentIsland + 1];
	else
		message = [super messageForPurchaseWithWorld:world];
	return message;
}

@end
