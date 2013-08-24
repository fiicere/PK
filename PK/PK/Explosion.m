//
//  Explosion.m
//  PK
//
//  Created by Kevin Yue on 8/15/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "Explosion.h"
#import "GameScene.h"

const CGFloat EX_HP = 1000000;
const CGFloat EX_DMG = 300;
const CGFloat EX_VAL = 0;
const CGFloat EX_BOUNCES = false;

const CGFloat EX_SIZE = 4;
const CGFloat EX_DUR = 1;

CGFloat t;


NSString* const EX_FILE = @"Shot.tif";

@implementation Explosion

-(id) init {
    self = [super initWithFile:EX_FILE];
    if(self){
        [self setStatsHP:EX_HP DMG:EX_DMG POINTS:EX_VAL BOUNCES:EX_BOUNCES];
        [self setScale:0.1];
        t = 0;
    }
	return self;
}

- (void) onTick:(ccTime)dt {
    [super onTick:dt];
    [self explode:dt];
}

-(void) explode:(ccTime)dt{
    t += dt;
    [self setScale:(t * EX_SIZE / EX_DUR)];
    if (t > EX_DUR){
        [self die];
    }
    
}
@end
