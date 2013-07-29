//
//  TurretShot.m
//  PK
//
//  Created by Kevin Yue on 7/16/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "TurretShot.h"
#import "PhysicsSprite.h"


const CGFloat TS_HP = 1;
const CGFloat TS_DMG = 1;
const CGFloat TS_VAL = 0;
const bool TS_BOUNCES = FALSE;

NSString* const TS_FILE = @"EnemyShot.tif";

@implementation TurretShot

-(id) init {
    self = [super initWithFile:TS_FILE];
    if(self){
        [self setStatsHP:TS_HP DMG:TS_DMG POINTS:TS_VAL BOUNCES:TS_BOUNCES];
    }
	return self;
}
@end
