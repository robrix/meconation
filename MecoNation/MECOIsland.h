//
//  MECOIsland.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-29.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MECOHouse, MECOPerson;

@protocol MECOIslandDelegate;

@interface MECOIsland : NSObject

+(NSArray *)allIslands;

@property (nonatomic, weak) id<MECOIslandDelegate> delegate;

@property (nonatomic, copy) NSString *name;

@property (strong) UIBezierPath *bezierPath;
@property CGRect bounds;

@property (strong) NSArray *houseLocations;

-(CGFloat)groundHeightAtX:(CGFloat)x;

@property (strong, readonly) NSSet *mecos;
-(void)addPerson:(MECOPerson *)person;
-(void)removePerson:(MECOPerson *)person;

@property (strong, readonly) NSSet *houses;
-(void)addHouse:(MECOHouse *)house;
-(void)removeHouse:(MECOHouse *)house;

@end

@protocol MECOIslandDelegate <NSObject>

-(void)island:(MECOIsland *)island didAddPerson:(MECOPerson *)person;
-(void)island:(MECOIsland *)island willRemovePerson:(MECOPerson *)person;

-(void)island:(MECOIsland *)island didAddHouse:(MECOHouse *)house;

@end
