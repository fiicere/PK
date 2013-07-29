//
//  WallOfDeath.m
//  PK
//
//  Created by Kevin Yue on 7/24/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "PhysicsSprite.h"
#import "WallOfDeath.h"


const CGFloat WOD_HP = 1000000;
const CGFloat WOD_DMG = 1000000;
const CGFloat WOD_VAL = 0;
const bool WOD_BOUNCES = TRUE;

NSString* const WOD_FILE = @" ";

@implementation WallOfDeath

-(id) init {
    self = [super initWithFile:WOD_FILE];
    if(self){
        [self setStatsHP:WOD_HP DMG:WOD_DMG POINTS:WOD_VAL BOUNCES:WOD_BOUNCES];
        [self schedule:@selector(regenerate:)];

    }
	return self;
}

-(void)regenerate:(ccTime)dt{
    if (self.health < WOD_HP){
        self.health =  WOD_HP;
    }
}


@end
