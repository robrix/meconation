//
//  MECOPerson.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MECOJob;

@interface MECOPerson : NSObject

+(NSString *)randomName;
+(MECOPerson *)personWithName:(NSString *)name job:(MECOJob *)job;

@property (copy, readonly) NSString *name;
@property (strong, readonly) MECOJob *job;

@property (weak) id sprite;

@end
