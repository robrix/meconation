//  MecoItem.m
//  Created by Rob Rix on 11-12-30.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import "MecoItem.h"
#import "MecoWorld.h"

@implementation MecoItem

-(NSUInteger)cost {
	[self doesNotRecognizeSelector:_cmd];
	return 0;
}

-(NSString *)label {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}


-(BOOL)canPurchaseWithWorld:(MecoWorld *)world {
	return (self.cost <= world.IQ);
}

-(NSString *)messageForPurchaseWithWorld:(MecoWorld *)world {
	NSString *message = nil;
	if(self.cost <= world.IQ)
		message = [NSString stringWithFormat:@"Bought a %@\nyou have %u IQ", self.label, world.IQ - self.cost];
	else
		message = [NSString stringWithFormat:@"You do not have enough IQ to buy a %@", self.label];
	return message;
}

-(void)attemptPurchaseWithWorld:(MecoWorld *)world {
	if([self canPurchaseWithWorld:world]) {
		[self purchaseWithWorld:world];
	}
}

-(void)purchaseWithWorld:(MecoWorld *)world {
	world.IQ -= self.cost;
}


-(id)initWithCoder:(NSCoder *)decoder {
	return [self init];
}

-(void)encodeWithCoder:(NSCoder *)encoder {}

@end
