//
//  MECOGroundView.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOGroundView.h"
#import "MECOIsland.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface MECOGroundView ()

@property (nonatomic, strong, readonly) CAShapeLayer *layer;

@end

@implementation MECOGroundView

@dynamic layer;

@synthesize island = _island;


+(Class)layerClass {
	return [CAShapeLayer class];
}


-(id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.layer.fillColor = [UIColor colorWithRed:51./255. green:153./255. blue:0./255. alpha:1.0].CGColor;
	}
	return self;
}


-(void)setIsland:(MECOIsland *)island {
	_island = island;
	
	UIBezierPath *path = island.bezierPath;
	[path applyTransform:CGAffineTransformMakeTranslation(0, self.bounds.size.height)];
	
	self.layer.path = path.CGPath;
}

@end
