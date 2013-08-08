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
#import "WorldBoundaries.h"
#import "Settings.h"
#import "WallOfDeath.h"

static FocusedLayer * el;
static FocusedLayer * epl;
static FocusedLayer * pl;
static BackgroundLayer * bl;
static BackgroundLayer * bl2;
static HelloWorldLayer * sl;
static FocusedLayer * gl;
static FocusedLayer * wodl;


@implementation GameScene

-(id) init{
    // 'scene' is an autorelease object.
	self = [super init];
	
    // Add enemies layer
    el = [FocusedLayer node];
    
    epl = [FocusedLayer node];
    
    // Add Projectiles layer
    pl = [FocusedLayer node];
    
    // Add WoD and Gradient layer
    if (Settings.getInstance.wt == DIRECTIONAL) {
        wodl = [FocusedLayer node];
        gl = [FocusedLayer node];
        
        [self addChild:wodl z:4];
        [self addChild: gl z:-1];
        if (wodl.children.count <=0) {
            [wodl addChild:[WallOfDeath getInstance]];
        }
    }
    
    // Add background layer
    bl = [[[BackgroundLayer alloc] initWithFile:@"Stars 2048x1536.tif" withDepth:-1] autorelease];
//    bl2 = [[[BackgroundLayer alloc] initWithFile:@"WhiteBackground.tif" withDepth:-2] autorelease];
    
	// 'layer' is an autorelease object.
    sl = [HelloWorldLayer node];
    
	// add layer as a child to scene
	[self addChild: sl z:3];
    [self addChild: el z:1];
    [self addChild: epl z:1];
    [self addChild: pl z:2];
    [self addChild: bl z:-2];
    
//    [self addChild:bl2 z:-9];
    
    
    [self schedule:@selector(layerBoundaries:)];
	// return the scene
	return self;
}

- (void) layerBoundaries:(ccTime)dt {
    for( FocusedLayer * layer in self.children){
        [[WorldBoundaries getInstance] updateLayer:layer];
    }
}

// Enemies Layer
+(FocusedLayer*)getEL{
    return el;
}

// Enemy Projectiles 
+(FocusedLayer*)getEPL{
    return epl;
}

// Ship Projectiles
+(FocusedLayer*)getPL{
    return pl;
}

// Background
+(BackgroundLayer*)getBL{
    return bl;
}

+(BackgroundLayer*)getBL2{
    return bl2;
}

// Gradient??
+(FocusedLayer*)getGL{
    return gl;
}

// Ship Layer
+(HelloWorldLayer*)getSL{
    return sl;
}

// WoD Layer
+(FocusedLayer*)getWoDL{
    return wodl;
}

@end
