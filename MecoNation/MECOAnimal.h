//
//  MECOAnimal.h
//  MecoNation
//
//  Created by Micah Merswolke on 2013-09-01.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOSaleItem.h"
@class MECOResource, MECOResourceCost;

@interface MECOAnimal : NSObject <MECOSaleItem, NSCopying>

+(NSArray *)animalsWithWorld:(MECOWorld *)world;

@property NSString *name;
@property UIImage *image;
@property MECOResource *resourceGiven;
@property MECOResource *rareResourceGiven;
@property float resourceAmount;

@end
