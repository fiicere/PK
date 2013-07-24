//
//  Projectile.m
//  PK
//
//  Created by Kevin Yue on 7/16/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "ShipShot.h"
#import "PhysicsSprite.h"

const CGFloat SS_HP = 1;
const CGFloat SS_DMG = 100;
const CGFloat SS_VAL = 0;
const CGFloat SS_BOUNCES = false;

NSString* const SS_FILE = @"Shot.tif";

@implementation ShipShot

-(id) init {
    self = [super initWithFile:SS_FILE];
    if(self){
        [self setStatsHP:SS_HP DMG:SS_DMG POINTS:SS_VAL BOUNCES:SS_BOUNCES];
    }
	return self;
}

@end
