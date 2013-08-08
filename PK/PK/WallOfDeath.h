//
//  WallOfDeath.h
//  PK
//
//  Created by Kevin Yue on 7/24/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhysicsSprite.h"
#import "cocos2d.h"

@interface WallOfDeath : PhysicsSprite {
    
}

+(WallOfDeath *) getInstance;
-(void)reset;

@end
