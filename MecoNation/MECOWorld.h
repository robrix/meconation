//
//  MECOWorld.h
//  MecoNation
//
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MECOWorld <NSObject>

@property NSUInteger IQ;
@property NSUInteger wood;
@property NSUInteger stone;
@property NSUInteger food;
@property NSUInteger wool;

@property NSArray *jobs;
@property NSDictionary *jobsByTitle;

@end
