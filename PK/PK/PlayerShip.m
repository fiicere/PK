//
//  PlayerShip.m
//  PK
//
//  Created by Kevin Yue on 7/16/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "PlayerShip.h"
#import "PhysicsSprite.h"
#import "GameOverLayer.h"
#import "HelloWorldLayer.h"

const CGFloat PS_HP = 100;
const CGFloat PS_DMG = 1000;
const CGFloat PS_VAL = 0;
const bool PS_BOUNCES = TRUE;

NSString* const PS_FILE = @"Player.tif";

@implementation PlayerShip

-(id) init {
    self = [super initWithFile:PS_FILE];
    if(self){
        [self setStatsHP:PS_HP DMG:PS_DMG POINTS:PS_VAL BOUNCES:PS_BOUNCES];
    }
	return self;
}
@end
