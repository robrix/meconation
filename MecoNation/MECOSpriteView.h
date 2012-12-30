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

@property (nonatomic, weak) id actor;

@property (nonatomic) CGPoint velocity;
@property (nonatomic) CGPoint inertia;

-(void)applyAcceleration:(CGPoint)acceleration;

-(void)updateWithInterval:(NSTimeInterval)interval;

@end


@protocol MECOSpriteViewDelegate <NSObject>

-(CGPoint)spriteView:(MECOSpriteView *)spriteView constrainPosition:(CGPoint)position;

@end
