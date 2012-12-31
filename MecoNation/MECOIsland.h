//
//  MECOIsland.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-29.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MECOIsland : NSObject

+(NSArray *)allIslands;

@property (strong) UIBezierPath *bezierPath;

-(CGFloat)groundHeightAtX:(CGFloat)x;

@end
