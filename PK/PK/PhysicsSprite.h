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
    CGFloat screenWidth;
    CGFloat screenHeight;
}
@property (nonatomic, assign) CGFloat xVel;
@property (nonatomic, assign) CGFloat yVel;
@property (nonatomic, assign) bool fixedPosition;
@property (nonatomic, assign) bool hasFrict;
@property (nonatomic, assign) CGFloat damage;
@property (nonatomic, assign) CGFloat health;
@property (nonatomic, assign) int points;
@property (nonatomic, assign) bool bounces;

-(void) pushWithXForce:(CGFloat)dX YForce:(CGFloat)dY;

-(void) setXVel:(CGFloat)xV YVel:(CGFloat)yV;

-(PhysicsSprite*) initWithFile:(NSString*)filename;

-(CGRect) getBoundingBox;

-(void) onTick:(ccTime)dt;

-(void) setStatsHP:(CGFloat)hp DMG:(CGFloat)dmg POINTS:(CGFloat)value BOUNCES:(bool)doesBounce;

-(void) die;



@end
