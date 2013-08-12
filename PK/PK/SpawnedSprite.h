//
//  SpawnedSprites.h
//  PK
//
//  Created by Kevin Yue on 8/12/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PhysicsSprite.h"

@interface SpawnedSprite : PhysicsSprite {
    
}

+(void)spawnEnemies:(ccTime)dt;
+(CGFloat)getSR;
+(CGFloat)getSST;

@end
