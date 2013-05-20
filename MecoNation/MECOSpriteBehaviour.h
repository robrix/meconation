//  MECOSpriteBehaviour.h
//  Created by Rob Rix on 2013-05-20.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import <Foundation/Foundation.h>

@class MECOSpriteView;

@protocol MECOSpriteBehaviour <NSObject>

-(void)applyToSprite:(MECOSpriteView *)sprite withInterval:(NSTimeInterval)interval;

@end


@interface MECOGravity : NSObject <MECOSpriteBehaviour>
@end


@interface MECOWanderingBehaviour : NSObject <MECOSpriteBehaviour>
@end
