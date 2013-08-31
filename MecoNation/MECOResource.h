//
//  MECOResource.h
//  MecoNation
//
//  Created by Rob Rix on 8/30/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MECOResourceDelegate;

@interface MECOResource : NSObject

+(instancetype)resourceWithName:(NSString *)name;

@property (nonatomic, weak) id<MECOResourceDelegate> delegate;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic) float quantity;

@end

@protocol MECOResourceDelegate <NSObject>

-(void)resourceDidChange:(MECOResource *)resource;

@end


@interface MECOResourceRate : NSObject

+(instancetype)rateWithResource:(MECOResource *)resource quantity:(float)quantity interval:(NSTimeInterval)interval;

@property (nonatomic, readonly) MECOResource *resource;
@property (nonatomic, readonly) float quantity;
@property (nonatomic, readonly) NSTimeInterval interval;

@end
