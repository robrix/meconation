//  MECOGeometry.h
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import <Foundation/Foundation.h>

static inline CGPoint MECOPointAdd(CGPoint a, CGPoint b) {
	return (CGPoint){ a.x + b.x, a.y + b.y };
}

static inline CGPoint MECOPointScale(CGPoint a, CGFloat t) {
	return (CGPoint){ a.x * t, a.y * t };
}
