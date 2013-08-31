//
//  MECOResource.h
//  MecoNation
//
//  Created by Rob Rix on 8/30/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MECOResource;
typedef void(^MECOResourceObservationBlock)(MECOResource *resource);

@interface MECOResource : NSObject

+(instancetype)resourceWithName:(NSString *)name onChange:(MECOResourceObservationBlock)block;
-(instancetype)initWithName:(NSString *)name onChange:(MECOResourceObservationBlock)block;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic) float quantity;

@end
