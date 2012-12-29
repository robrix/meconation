//  MecoWorld.m
//  Created by Rob Rix on 11-12-30.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import "MecoIsland.h"
#import "MecoPerson.h"
#import "MecoWorld.h"
#import "MecoJob.h"
//#import "RXCollection.h"

@interface MecoWorld ()

@property (strong, readwrite) NSString *backlog;

@property (readonly) NSUInteger mecoCount;
@property (readonly) NSUInteger houseCount;
@property (readonly) NSUInteger scientistCount;

@property (strong) NSTimer *IQTimer;

@end


@implementation MecoWorld

@synthesize islands, currentIsland, mecos, IQ, backlog, delegate, IQTimer, IQInterval;


-(id)init {
	if((self = [super init])) {
		IQInterval = 60.0;
	}
	return self;
}

+(MecoWorld *)worldWithIslands:(NSArray *)islands mecos:(NSSet *)mecos {
	MecoWorld *world = [self new];
	world->islands = [islands copy];
	world->currentIsland = [islands objectAtIndex:0];
	world->mecos = [mecos mutableCopy];
	world->IQ = 10;
	world->backlog = @"";
	return world;
}

-(void)dealloc {
	[IQTimer invalidate];
}


-(void)addIntroduction {
	[self addResultLinesToBacklog:[NSString stringWithFormat: @"You are on island%u", self.indexOfCurrentIsland+1 ]];
	[self addResultLinesToBacklog:[NSString stringWithFormat: @"You have %u mecos", self.mecoCount]];
	[self addResultLinesToBacklog:[NSString stringWithFormat: @"You have %u houses", self.houseCount]];
	[self addResultLinesToBacklog:[NSString stringWithFormat:@"You have %u IQ", self.IQ]];
	[self addResultLinesToBacklog:@"You have 0 wool"];
	[self addResultLinesToBacklog:@"You have 0 fur"];
	[self addResultLinesToBacklog:@"For command list type 'help'"];
}

-(void)scheduleIQTimer {
	[self.IQTimer invalidate];
	self.IQTimer = [NSTimer scheduledTimerWithTimeInterval:IQInterval target:self selector:@selector(IQTimerDidFire:) userInfo:nil repeats:NO];
}


-(NSUInteger)indexOfCurrentIsland {
	return [islands indexOfObject:currentIsland];
}

-(void)setMecos:(NSSet *)_mecos {
	[mecos setSet:_mecos];
}

-(void)addMeco:(MecoPerson *)meco {
	[mecos addObject:meco];
}

-(NSUInteger)mecoCount {
	return mecos.count;
}

-(NSUInteger)houseCount {
	NSUInteger houseCount = 0;
	for(MecoIsland *island in islands) {
		houseCount += island.houseCount;
	}
	return houseCount;
}

-(NSUInteger)scientistCount {
	return 1;
//	return [NSSet rx_setByFilteringCollection:mecos withBlock:^BOOL(id person) {
//		return [[[person job] title] isEqualToString:@"scientist"];
//	}].count;
}


-(NSUInteger)maximumPopulation {
	return self.houseCount * 4 - 1;
}


-(void)setIQInterval:(NSTimeInterval)_IQInterval {
	IQInterval = _IQInterval;
	[self scheduleIQTimer];
}


-(void)addResultLinesToBacklog:(NSString *)result {
	NSMutableArray *lines = [NSMutableArray array];
	for(NSString *line in [result componentsSeparatedByString:@"\n"]) {
		[lines addObject:[NSString stringWithFormat:@"> %@", line]];
	}
	[self addLinesToBacklog:[lines componentsJoinedByString:@"\n"]];
}

-(void)addLinesToBacklog:(NSString *)line {
	self.backlog = [self.backlog stringByAppendingString:[line stringByAppendingString:@"\n"]];
	[delegate world:self didAddBacklog:line];
}


-(void)IQTimerDidFire:(NSTimer *)timer {
	self.IQ = self.IQ + 10 * self.scientistCount;
	[self addResultLinesToBacklog:[NSString stringWithFormat:NSLocalizedString(@"You have %u IQ", nil), IQ]];
	[self scheduleIQTimer];
}


-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInteger:IQ forKey:@"IQ"];
	[encoder encodeObject:islands forKey:@"islands"];
	[encoder encodeObject:mecos forKey:@"mecos"];
	[encoder encodeInteger:self.indexOfCurrentIsland forKey:@"indexOfCurrentIsland"];
	[encoder encodeObject:backlog forKey:@"backlog"];
}

-(id)initWithCoder:(NSCoder *)decoder {
	if((self = [self init])) {
		IQ = [decoder decodeIntegerForKey:@"IQ"];
		islands = [decoder decodeObjectForKey:@"islands"];
		currentIsland = [islands objectAtIndex:[decoder decodeIntegerForKey:@"indexOfCurrentIsland"]];
		mecos = [[decoder decodeObjectForKey:@"mecos"] mutableCopy];
		backlog = [decoder decodeObjectForKey:@"backlog"];
	}
	return self;
}

@end
