//  MecoJob.h
//  Created by Rob Rix on 11-12-30.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface MecoJob : NSObject <NSCoding>

+(MecoJob *)job;

@property (copy, readonly) NSString *title;

@end
