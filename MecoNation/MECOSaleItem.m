//
//  MECOSaleItem.m
//  MecoNation
//
//  Created by Rob Rix on 9/1/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOSaleItem.h"
#import "MECOResource.h"

NSString *MECOSaleItemWarningForCost(MECOResourceCost *cost) {
	return cost.isAffordable?
		nil
	:	[NSString stringWithFormat:@"You need %g %@", cost.quantity, cost.resource.name];
}

NSArray *MECOSaleItemWarningsForUnaffordableCosts(id<MECOSaleItem> saleItem) {
	NSMutableArray *warnings = [NSMutableArray new];
	for (MECOResourceCost *cost in saleItem.costs) {
		NSString *warning = MECOSaleItemWarningForCost(cost);
		if (warning)
			[warnings addObject:warning];
	}
	return warnings;
}

bool MECOSaleItemIsAffordable(id<MECOSaleItem> saleItem) {
	bool isAffordable = YES;
	for (MECOResourceCost *cost in saleItem.costs) {
		if (!cost.isAffordable) {
			isAffordable = NO;
			break;
		}
	}
	return isAffordable;
}


void MECOSaleItemSubtractCosts(id<MECOSaleItem> saleItem) {
	for (MECOResourceCost *cost in saleItem.costs) {
		[cost subtract];
	}
}

NSArray *MECOSaleItemPurchase(id<MECOSaleItem> saleItem, void(^block)()) {
	NSArray *warnings = MECOSaleItemWarningsForUnaffordableCosts(saleItem);
	if (warnings.count == 0) {
		MECOSaleItemSubtractCosts(saleItem);
		block();
	}
	return warnings;
}
