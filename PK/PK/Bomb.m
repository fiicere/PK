//
//  Bomb.m
//  PK
//
//  Created by Kevin Yue on 8/15/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "Bomb.h"
#import "GameScene.h"
#import "Explosion.h"

const CGFloat B_HP = 1;
const CGFloat B_DMG = 100;
const CGFloat B_VAL = 0;
const CGFloat B_BOUNCES = false;

CGFloat dist;

CGPoint dest;

NSString* const B_FILE = @"seeker.png";

@implementation Bomb

-(id) init {
    self = [super initWithFile:B_FILE];
    dist = FLT_MAX;
    if(self){
        [self setStatsHP:B_HP DMG:B_DMG POINTS:B_VAL BOUNCES:B_BOUNCES];
    }
	return self;
}

-(id) initWithDest:(CGPoint)destination {
    dest = destination;
    return [self init];
}

- (void) onTick:(ccTime)dt {
    [super onTick:dt];
    [self checkExplody];
}

-(void) checkExplody{
    CGFloat dx = self.position.x - dest.x;
    CGFloat dy = self.position.y - dest.y;
    CGFloat newDist = dx*dx + dy*dy;
    if (newDist > dist){
        [self boom];
        return;
    }
    else{
        dist = newDist;
    }
}


-(void) boom{
    Explosion *newExp = [[Explosion alloc] init];
    [[GameScene getEXL] addChild:newExp];
    [newExp setPosition:self.position];
    [self die];
}
@end
