//
//  WorldBoundaries.h
//  PK
//
//  Created by Kevin Yue on 7/16/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PhysicsSprite.h"
#import "FocusedLayer.h"

@interface WorldBoundaries : NSObject


+(WorldBoundaries*) getInstance;
-(void)updateAgent:(PhysicsSprite *)agent;
-(void)updateLayer:(FocusedLayer *) layer;

@end
