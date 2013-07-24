//
//  BasicEnemy.m
//  PK
//
//  Created by Kevin Yue on 7/16/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "BasicEnemy.h"
#import "PhysicsSprite.h"

const CGFloat BE_HP = 100;
const CGFloat BE_DMG = 100;
const CGFloat BE_VAL = 1;
const bool BE_BOUNCES = true;

NSString* const BE_FILE = @"EnemyA.tif";

@implementation BasicEnemy

-(id) init {
    self = [super initWithFile:BE_FILE];
    if(self){
        [self setStatsHP:BE_HP DMG:BE_DMG POINTS:BE_VAL BOUNCES:BE_BOUNCES];
    }
	return self;
}
@end
