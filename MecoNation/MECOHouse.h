//  MECOHouse.h
//  Created by Rob Rix on 2013-05-19.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import <Foundation/Foundation.h>

@interface MECOHouse : NSObject

+(instancetype)houseWithLocation:(CGPoint)location;

@property (nonatomic, readonly) CGPoint location;

@property (nonatomic, weak) id sprite;

@end
