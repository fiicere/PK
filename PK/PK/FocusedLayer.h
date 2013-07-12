//
//  FocusedLayer.h
//  PK
//
//  Created by Kevin Yue on 7/8/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PhysicsSprite.h"

@interface FocusedLayer : CCLayer {
    PhysicsSprite *focus;

}
@property (nonatomic, assign) CGFloat xVel;
@property (nonatomic, assign) CGFloat yVel;

-(void) setFocus:(PhysicsSprite*)f;

@end
