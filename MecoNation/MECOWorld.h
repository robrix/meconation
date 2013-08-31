//
//  MECOWorld.h
//  MecoNation
//
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

@class MECOResource;
@protocol MECOWorldDelegate;

@interface MECOWorld : NSObject

@property (nonatomic, weak) id<MECOWorldDelegate> delegate;

#pragma mark Resources

@property (nonatomic, readonly) MECOResource *foodResource;
@property (nonatomic, readonly) MECOResource *IQResource;
@property (nonatomic, readonly) MECOResource *stoneResource;
@property (nonatomic, readonly) MECOResource *woodResource;
@property (nonatomic, readonly) MECOResource *woolResource;

@property (nonatomic, readonly) NSArray *resources;

#pragma mark Jobs

@property (nonatomic, readonly) NSArray *jobs;
@property (nonatomic, readonly) NSDictionary *jobsByTitle;

#pragma mark Islands

@property (nonatomic, readonly) NSArray *islands;

@property (nonatomic, readonly) NSSet *allMecos;
@property (nonatomic, readonly) NSSet *allHouses;

@property (nonatomic, readonly) NSUInteger currentPopulation;
@property (nonatomic, readonly) NSUInteger maximumPopulation;

@end

@protocol MECOWorldDelegate <NSObject>

-(void)world:(MECOWorld *)world didChangeResource:(MECOResource *)resource;

@end
