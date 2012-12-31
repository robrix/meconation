//
//  MECOAssignSegue.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-31.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOAssignSegue.h"

@implementation MECOAssignSegue

-(void)perform {
	[self.sourceViewController setValue:self.destinationViewController forKey:self.identifier];
}

@end
