//
//  MECOSaleItem.m
//  MecoNation
//
//  Created by Rob Rix on 9/1/2013.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.
//

#import "MECOSaleItem.h"
#import "MECOResource.h"

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