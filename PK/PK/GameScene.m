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

static FocusedLayer * el;
static FocusedLayer * epl;
static FocusedLayer * pl;
static BackgroundLayer * bl;
static BackgroundLayer * bl2;
static HelloWorldLayer * sl;


@implementation GameScene

-(id) init{
    // 'scene' is an autorelease object.
	self = [super init];
	
    // Add enemies layer
    el = [FocusedLayer node];
    
    epl = [FocusedLayer node];
    
    // Add Projectiles layer
    pl = [FocusedLayer node];
    
    // Add background layer
    bl = [[[BackgroundLayer alloc] initWithFile:@"Stars 2048x1536.tif"] autorelease];
    bl2 = [[[BackgroundLayer alloc] initWithFile:@"Stars 2048x1536.tif"] autorelease];
    
	// 'layer' is an autorelease object.
    sl = [HelloWorldLayer node];
    
	// add layer as a child to scene
	[self addChild: sl];
    [self addChild: el];
    [self addChild: epl];
    [self addChild: pl];
    [self addChild: bl z:-1];
    [bl2 setParallaxFactor:0.7];
    [self addChild:bl2 z:-1];
    
    
    [self schedule:@selector(layerBoundaries:)];
	// return the scene
	return self;
}

- (void) layerBoundaries:(ccTime)dt {
    for( FocusedLayer * layer in self.children){
        [[WorldBoundaries getInstance] updateLayer:layer];
    }
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

+(BackgroundLayer*)getBL2{
    return bl2;
}

+(HelloWorldLayer*)getSL{
    return sl;
}

@end
