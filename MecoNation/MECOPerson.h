//
//  MECOPerson.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MECOJob;

@protocol MECOPersonDelegate;

@interface MECOPerson : NSObject

+(NSString *)randomName;
+(MECOPerson *)personWithName:(NSString *)name job:(MECOJob *)job;

@property (nonatomic, weak) id<MECOPersonDelegate> delegate;

@property (copy, readonly) NSString *name;
@property (nonatomic, strong) MECOJob *job;

@property (readonly) NSString *label;

@property (weak) id sprite;

@end

@protocol MECOPersonDelegate <NSObject>
@optional

-(void)person:(MECOPerson *)person willQuitJob:(MECOJob *)job;
-(void)person:(MECOPerson *)person didStartJob:(MECOJob *)job;

@end
