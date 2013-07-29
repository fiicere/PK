//
//  DeathWall.m
//  PK
//
//  Created by PHILLIP SEO on 7/29/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "DeathWall.h"
#import "PhysicsSprite.h"

const CGFloat DW_HP = 1000000000;
const CGFloat DW_DMG = 10000;
const CGFloat DW_VAL = 10000;
const bool DW_BOUNCES = false;

NSString* const DW_FILE = @"DeathWall.tif";

@implementation DeathWall

-(id) init {
    self = [super initWithFile:DW_FILE];
    if (self) {
        [self setStatsHP:DW_HP DMG:DW_DMG POINTS:DW_VAL BOUNCES:DW_BOUNCES];
        [self schedule:@selector(stayAlive:)];
    }
    return self;
}

-(void) stayAlive:(ccTime)dt{
    [self setStatsHP:DW_HP DMG:DW_DMG POINTS:DW_VAL BOUNCES:DW_BOUNCES];
}

@end
