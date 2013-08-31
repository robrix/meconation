//
//  MECOWorld.h
//  MecoNation
//
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOResource.h"

@protocol MECOWorld <NSObject>

@property (nonatomic, readonly) MECOResource *foodResource;
@property (nonatomic, readonly) MECOResource *IQResource;
@property (nonatomic, readonly) MECOResource *stoneResource;
@property (nonatomic, readonly) MECOResource *woodResource;
@property (nonatomic, readonly) MECOResource *woolResource;

@property NSArray *jobs;
@property NSDictionary *jobsByTitle;

@end
