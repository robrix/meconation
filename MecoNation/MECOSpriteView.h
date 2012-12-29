//
//  MECOSpriteView.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MECOSpriteViewDelegate;

@interface MECOSpriteView : UIView

@property (nonatomic, weak) id<MECOSpriteViewDelegate> delegate;

@property (nonatomic, strong) UIImage *image;

@end


@protocol MECOSpriteViewDelegate <NSObject>

-(bool)spriteView:(MECOSpriteView *)spriteView shouldMoveToDestination:(CGPoint)destination;

@end