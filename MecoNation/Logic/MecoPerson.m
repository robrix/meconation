//  MecoPerson.m
//  Created by Rob Rix, and Hac!m on 11-12-29.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import "MecoPerson.h"
#import "MecoWorld.h"
#import "MecoJob.h"

@implementation MecoPerson

@synthesize name, job;
//this is what a meco is:

//if a meco has a job... what is it?
+(MecoPerson *)personWithJob:(MecoJob *)job {
	MecoPerson *person = [self new];
	person->job = job;
	return person;
}

//The meco's cost
-(NSUInteger)cost {
	return 100;
}
//what to print to the screen when asked what a meco is
//buy MECO
//you bought a MECO
-(NSString *)label {
	return @"meco";
}

//you can purchase a meco if you have enough space in your world for that meco.
-(BOOL)canPurchaseWithWorld:(MecoWorld *)world {
	return
		[super canPurchaseWithWorld:world]
	&&	(world.mecos.count < world.maximumPopulation);
}
//if Player has too many mecos already... let them know they need a house
//otherwise... let them know they've bought the meco
-(NSString *)messageForPurchaseWithWorld:(MecoWorld *)world {
	NSString *message = nil;
	if(world.mecos.count >= world.maximumPopulation)
		message = @"You will need to buy another house first";
	else
		message = [super messageForPurchaseWithWorld:world];
	return message;
}

//any new mecos, dont have a pre-set job
-(void)purchaseWithWorld:(MecoWorld *)world {
	[super purchaseWithWorld:world];
	[world addMeco:[MecoPerson personWithJob:nil]];
}

//store a mecos information
-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:job forKey:@"job"];
}
//retrieve the mecos information later
-(id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		name = [decoder decodeObjectForKey:@"name"];
		job = [decoder decodeObjectForKey:@"job"];
	}
	return self;
}

@end
