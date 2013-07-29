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

enum worldType
{
    OPEN,
    BOX,
    DIRECTIONAL
};

+(WorldBoundaries*) getInstance;
-(void)updateAgent:(PhysicsSprite *)agent;
-(void)updateLayer:(FocusedLayer *) layer;
-(void)setWorldType:(enum worldType) type;
-(enum worldType)getWorldType;
@end
