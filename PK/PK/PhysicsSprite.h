//
//  PhysicsSprite.h
//  PK
//
//  Created by Kevin Yue on 7/8/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PhysicsSprite : CCSprite {
    
}
@property (nonatomic, assign) CGFloat xVel;
@property (nonatomic, assign) CGFloat yVel;

// Fixes the sprite in position
-(void)fixPosition;

-(void)setFriction;

-(void)setVelocitydX:(CGFloat)newXVel dY:(CGFloat)newYVel;

-(void)incVelocitydX:(CGFloat)dX dY:(CGFloat)dY;

@end
