//
//  WallOfDeath.m
//  PK
//
//  Created by Kevin Yue on 7/24/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "PhysicsSprite.h"
#import "WallOfDeath.h"
#import "Clock.h"


const CGFloat WOD_HP = 1000000;
const CGFloat WOD_DMG = 1000000;
const CGFloat WOD_VAL = 0;
const bool WOD_BOUNCES = TRUE;

const CGFloat WOD_VEL = 50;

static WallOfDeath* instance;

NSString* const WOD_FILE = @"DeathWall.tif";

@implementation WallOfDeath

+(WallOfDeath *) getInstance{
    if (instance == nil) {
        instance = [[[self alloc]init]autorelease];
    }
    return instance;
}

-(id) init {
    self = [super initWithFile:WOD_FILE];
    if(self){
        [self setStatsHP:WOD_HP DMG:WOD_DMG POINTS:WOD_VAL BOUNCES:WOD_BOUNCES];
        [self schedule:@selector(update:)];
        self.position = ccp(-1800, screenHeight/2);
    }
	return self;
}

-(void)reset{
    instance = [[[WallOfDeath alloc]init]autorelease];
    self.position = ccp(-1800, screenHeight/2);
    [self setXVel:0];
    [self setYVel:0];
}

-(void)update:(ccTime)dt{
    if (self.health < WOD_HP){
        self.health =  WOD_HP;
    }
    [self setXVel:(WOD_VEL * sqrt([Clock getInstance].getTime))];
}


@end
