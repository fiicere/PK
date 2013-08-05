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
static HelloWorldLayer * sl;
static FocusedLayer * gl;


@implementation GameScene

-(id) init{
    // 'scene' is an autorelease object.
	self = [super init];
	
    // Add enemies layer
    el = [FocusedLayer node];
    
    epl = [FocusedLayer node];
    
    // Add Projectiles layer
    pl = [FocusedLayer node];
    
    gl = [FocusedLayer node];
    
    // Add background layer
    bl = [[[BackgroundLayer alloc] initWithFile:@"Stars 2048x1536.tif" withDepth:-1] autorelease];
    
	// 'layer' is an autorelease object.
    sl = [HelloWorldLayer node];
    
	// add layer as a child to scene
	[self addChild: sl z:3];
    [self addChild: el z:1];
    [self addChild: epl z:1];
    [self addChild: pl z:2];
    [self addChild: bl z:-1];
    [self addChild: gl z:-2];
    
    
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

+(FocusedLayer*)getGL{
    return gl;
}

+(HelloWorldLayer*)getSL{
    return sl;
}

@end
