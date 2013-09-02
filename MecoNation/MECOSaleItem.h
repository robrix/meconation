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

/**
 Subtracts the costs from their respective resources and runs the block if the item can be afforded.
 
 @return An empty array if the sale item could be afforded, or an array of warnings about the unaffordable costs otherwise.
 */
extern NSArray *MECOSaleItemPurchase(id<MECOSaleItem> saleItem, void(^block)());
