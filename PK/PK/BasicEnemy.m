//
//  BasicEnemy.m
//  PK
//
//  Created by Kevin Yue on 7/16/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "BasicEnemy.h"
#import "PhysicsSprite.h"
#import "RandomTrajectory.h"
#import "GameScene.h"

const CGFloat BE_HP = 150;
const CGFloat BE_DMG = 33;
const CGFloat BE_VAL = 1;

// Movement stats
const int BE_VEL_MIN = 100;
const int BE_VEL_MAX = 200;

// Spawn Stats
const CGFloat BE_SR = 1;
const CGFloat BE_SST = 0;

const bool BE_BOUNCES = true;

NSString* const BE_FILE = @"EnemyA.tif";

@implementation BasicEnemy

-(id) init {
    self = [super initWithFile:BE_FILE];
    if(self){
        [self setStatsHP:BE_HP DMG:BE_DMG POINTS:BE_VAL BOUNCES:BE_BOUNCES];
        [self setStartingStats];
    }
	return self;
}

-(void) setStartingStats{
    RandomTrajectory *t = [[RandomTrajectory alloc] init];
    
    // Randomly choose the UFO's speed
    CGFloat vel = (arc4random() % (BE_VEL_MAX-BE_VEL_MIN)) + BE_VEL_MIN;
    self.position = ccp(t.startX - [GameScene getEL].position.x, t.startY - [GameScene getEL].position.y);
    
    [self pushWithXForce:t.trajdX*vel/t.norm YForce:t.trajdY*vel/t.norm];
    
    [t dealloc];
}

+(CGFloat)getSR{
    return BE_SR;
}
+(CGFloat)getSST{
    return BE_SST;
}
@end
