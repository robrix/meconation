//
//  MECOResource.h
//  MecoNation
//
//  Created by Rob Rix on 8/30/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MECOResource : NSObject

+(instancetype)resourceWithName:(NSString *)name;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic) float quantity;

@end

extern NSString * const MECOResourceDidChangeNotification;

@interface MECOResourceRate : NSObject

+(instancetype)rateWithResource:(MECOResource *)resource quantity:(float)quantity interval:(NSTimeInterval)interval;

@property (nonatomic, readonly) MECOResource *resource;
@property (nonatomic, readonly) float quantity;
@property (nonatomic, readonly) NSTimeInterval interval;

@end
