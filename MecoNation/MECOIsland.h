//
//  MECOIsland.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-29.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MECOPerson;

@interface MECOIsland : NSObject

+(NSArray *)allIslands;

@property (strong) UIBezierPath *bezierPath;
@property CGRect bounds;

-(CGFloat)groundHeightAtX:(CGFloat)x;

@property (strong, readonly) NSSet *mecos;
-(void)addPerson:(MECOPerson *)person;
-(void)removePerson:(MECOPerson *)person;

@end
