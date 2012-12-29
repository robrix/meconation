//  MecoWorld.h
//  Created by Rob Rix on 11-12-30.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@class MecoIsland, MecoPerson;
@protocol MecoWorldDelegate;

@interface MecoWorld : NSObject <NSCoding> {
	NSArray *islands;
	MecoIsland *currentIsland;
	NSMutableSet *mecos;
	NSUInteger IQ;
	NSTimer *IQTimer;
	NSString *backlog;
	NSTimeInterval IQInterval;
	id<MecoWorldDelegate> __unsafe_unretained delegate;
	// resources (wool, fur)
	// sheep
	// bridges
	// pigs
	// boat?
	// boat AI?
}

+(MecoWorld *)worldWithIslands:(NSArray *)islands mecos:(NSSet *)mecos;

@property (readonly) NSArray *islands;
@property (readonly) MecoIsland *currentIsland;
@property (readonly) NSUInteger indexOfCurrentIsland;
@property (nonatomic, copy) NSSet *mecos;

-(void)addMeco:(MecoPerson *)meco;

@property (assign) NSUInteger IQ;
@property (nonatomic, assign) NSTimeInterval IQInterval;

@property (readonly) NSUInteger maximumPopulation;

@property (strong, readonly) NSString *backlog;
-(void)addResultLinesToBacklog:(NSString *)result;
-(void)addLinesToBacklog:(NSString *)line;

-(void)addIntroduction;
-(void)scheduleIQTimer;

@property (unsafe_unretained) id<MecoWorldDelegate> delegate;

@end


@protocol MecoWorldDelegate <NSObject>

-(void)world:(MecoWorld *)world didAddBacklog:(NSString *)line;

@end
