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
@property (nonatomic, assign) bool fixedPosition;
@property (nonatomic, assign) bool hasFrict;

-(void) pushWithXForce:(CGFloat)dX YForce:(CGFloat)dY;

-(void) setXVel:(CGFloat)xV YVel:(CGFloat)yV;

-(PhysicsSprite*) createWithFile:(NSString*)filename;

-(CGRect) getBoundingBox;



@end
