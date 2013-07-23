//
//  WorldBoundaries.m
//  PK
//
//  Created by Kevin Yue on 7/16/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import "WorldBoundaries.h"
#import "PhysicsSprite.h"
#import "FocusedLayer.h"

const CGFloat LIMITS_OF_REALITY = 1000;

static WorldBoundaries *instance;

enum worldType wt = BOX;

// World info
CGFloat screenWidth;
CGFloat screenHeight;
CGFloat realityMinX;
CGFloat realityMinY;
CGFloat realityMaxX;
CGFloat realityMaxY;
CGFloat realityWidth;
CGFloat realityHeight;

@implementation WorldBoundaries

+(WorldBoundaries*) getInstance{
    if(instance == nil){
        instance = [[self alloc] init];
    }
    return instance;
}

-(id)init{
    if(self = [super init]){
        [self setupVariables];
    }
    return self;
}

-(void)setupVariables{
    screenHeight = CCDirector.sharedDirector.winSize.height;
    screenWidth = CCDirector.sharedDirector.winSize.width;
    realityMaxX = screenWidth + LIMITS_OF_REALITY;
    realityMaxY = screenHeight + LIMITS_OF_REALITY;
    realityMinX = - LIMITS_OF_REALITY;
    realityMinY = - LIMITS_OF_REALITY;
    
    realityWidth = realityMaxX - realityMinX;
    realityHeight = realityMaxY - realityMinY;
}

-(void)updateAgent:(PhysicsSprite *)agent{
    
    switch (wt) {
        case OPEN:
            [self openWorldAgent:agent];
            break;
        case BOX:
            [self boxWorldAgent:agent];
            break;
        case DIRECTIONAL:
            [self directionalWorldAgent:agent];
            break;
        default:
            break;
    }
}

// World rules for open world
-(void) openWorldAgent:(PhysicsSprite *)agent{
    CGFloat aX = [agent.parent convertToWorldSpace:agent.position].x;
    CGFloat aY = [agent.parent convertToWorldSpace:agent.position].y;
    
    if(aX < realityMinX){
        [agent die];
    }
    if(aX > realityMaxX){
        [agent die];
    }
    if(aY < realityMinY){
        [agent die];
    }
    if(aY > realityMaxY){
        [agent die];
    }
}

// World rules for box world
// TODO!!! Make relevant to world position only!!!
-(void) boxWorldAgent:(PhysicsSprite *)agent{
    
    if(agent.position.x < realityMinX){
        [agent setPosition:ccp(realityMinX, agent.position.y)];
        [agent setXVel:(fabsf(agent.xVel))];
    }
    if(agent.position.x > realityMaxX){
        [agent setPosition:ccp(realityMaxX, agent.position.y)];
        [agent setXVel:(-fabsf(agent.xVel))];
    }
    if(agent.position.y < realityMinY){
        [agent setPosition:ccp(agent.position.x, realityMinY)];
        [agent setYVel:(fabsf(agent.yVel))];
    }
    if(agent.position.y > realityMaxY){
        [agent setPosition:ccp(agent.position.x, realityMaxY)];
        [agent setYVel:(-fabsf(agent.yVel))];
    }
}

-(void) directionalWorldAgent:(PhysicsSprite *)agent{
    //TODO
}



-(void)updateLayer:(FocusedLayer *)layer{
    switch (wt) {
        case OPEN:
            [self openWorldLayer:layer];
            break;
        case BOX:
            [self boxWorldLayer:layer];
            break;
        case DIRECTIONAL:
            [self directionalWorldLayer:layer];
            break;
        default:
            break;
    }
}

// World rules for open world
-(void) openWorldLayer:(FocusedLayer *)layer{
    CGFloat aX = [layer.parent convertToWorldSpace:layer.position].x;
    CGFloat aY = [layer.parent convertToWorldSpace:layer.position].y;
    
    if(aX < realityMinX){
    }
    if(aX > realityMaxX){
    }
    if(aY < realityMinY){
    }
    if(aY > realityMaxY){
    }
}

// World rules for box world
// TODO!!! Make relevant to world position only!!!
-(void) boxWorldLayer:(FocusedLayer *)layer{
    CGFloat lX = - layer.position.x;
    CGFloat lY = - layer.position.y;
    
    if(lX < realityMinX){
        [layer setPosition:ccp(- realityMinX, layer.position.y)];
        [layer setXVel:(fabsf(layer.xVel))];
    }
    if(lX > realityMaxX){
        [layer setPosition:ccp(- realityMaxX, layer.position.y)];
        [layer setXVel:(-fabsf(layer.xVel))];
    }
    if(lY < realityMinY){
        [layer setPosition:ccp(layer.position.x, - realityMinY)];
        [layer setYVel:(fabsf(layer.yVel))];
    }
    if(lY > realityMaxY){
        [layer setPosition:ccp(layer.position.x, - realityMaxY)];
        [layer setYVel:(-fabsf(layer.yVel))];
        
    }
}

-(void) directionalWorldLayer:(FocusedLayer *)layer{
    //TODO
}

@end
