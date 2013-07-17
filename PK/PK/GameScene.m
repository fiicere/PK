//
//  GameScene.m
//  PK
//
//  Created by Kevin Yue on 7/17/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "GameScene.h"
#import "FocusedLayer.h"
#import "BackgroundLayer.h"
#import "HelloWorldLayer.h"

static FocusedLayer * el;
static FocusedLayer * epl;
static FocusedLayer * pl;
static BackgroundLayer * bl;
static HelloWorldLayer * sl;


@implementation GameScene

-(id) init{
    // 'scene' is an autorelease object.
	self = [CCScene node];
	
    // Add enemies layer
    el = [FocusedLayer node];
    
    epl = [FocusedLayer node];
    
    // Add Projectiles layer
    pl = [FocusedLayer node];
    
    // Add background layer
    bl = [BackgroundLayer node];
    
	// 'layer' is an autorelease object.
    sl = [HelloWorldLayer node];
    
	// add layer as a child to scene
	[self addChild: sl];
    [self addChild: el];
    [self addChild: epl];
    [self addChild: pl];
    [self addChild: bl z:-1];
    
	// return the scene
	return self;
}

+(FocusedLayer*)getEL{
    return el;
}

+(FocusedLayer*)getEPL{
    return epl;
}

+(FocusedLayer*)getPL{
    return pl;
}

+(BackgroundLayer*)getBL{
    return bl;
}
+(HelloWorldLayer*)getSL{
    return sl;
}

@end
