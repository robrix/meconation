//
//  MECOSaleItem.h
//  MecoNation
//
//  Created by Rob Rix on 9/1/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MECOSaleItem <NSObject>

@property (nonatomic, copy, readonly) NSArray *costs;

@end

extern NSArray *MECOSaleItemWarningsForUnaffordableCosts(id<MECOSaleItem> saleItem);
extern bool MECOSaleItemIsAffordable(id<MECOSaleItem> saleItem);
