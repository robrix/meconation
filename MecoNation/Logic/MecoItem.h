//  MecoItem.h
//  Created by Rob Rix on 11-12-30.
//  Copyright (c) 2011 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@class MecoWorld;

@interface MecoItem : NSObject <NSCoding>

@property (readonly) NSUInteger cost;
@property (readonly) NSString *label;

-(BOOL)canPurchaseWithWorld:(MecoWorld *)world;
-(NSString *)messageForPurchaseWithWorld:(MecoWorld *)world;
-(void)attemptPurchaseWithWorld:(MecoWorld *)world;
-(void)purchaseWithWorld:(MecoWorld *)world;

@end
