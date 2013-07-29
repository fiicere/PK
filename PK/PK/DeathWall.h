//
//  DeathWall.h
//  PK
//
//  Created by PHILLIP SEO on 7/29/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PhysicsSprite.h"

@interface DeathWall : PhysicsSprite {
    
}

-(void) stayAlive:(ccTime)dt;

@end
