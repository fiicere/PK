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

-(void) fixPosition:(bool)fixed;

-(void) toggleFrict:(bool)friction;

-(void) pushWithXForce:(CGFloat)dX YForce:(CGFloat)dY;

-(void) setXVel:(CGFloat)xV YVel:(CGFloat)yV;



@end
