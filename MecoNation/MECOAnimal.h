//
//  MECOAnimal.h
//  MecoNation
//
//  Created by Micah Merswolke on 2013-09-01.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MECOResource;

@interface MECOAnimal : NSObject

@property NSString *name;
@property UIImage *image;
@property MECOResource *resourceGiven;
@property MECOResource *rareResourceGiven;
@property float resourceAmount;
@property float IQCost;
+(NSArray *)animalsWithWorld:(MECOWorld *)world;

@end
