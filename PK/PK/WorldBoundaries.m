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
#import "Settings.h"

const CGFloat LIMITS_OF_REALITY = 1000;

static WorldBoundaries *instance;

// World info
CGFloat screenWidth;
CGFloat screenHeight;

CGFloat realityWidth;
CGFloat realityHeight;

CGFloat agentMinX;
CGFloat agentMinY;
CGFloat agentMaxX;
CGFloat agentMaxY;

CGFloat layerMinX;
CGFloat layerMinY;
CGFloat layerMaxX;
CGFloat layerMaxY;

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
    
    agentMaxX = screenWidth + LIMITS_OF_REALITY;
    agentMaxY = screenHeight + LIMITS_OF_REALITY;
    agentMinX = - LIMITS_OF_REALITY;
    agentMinY = - LIMITS_OF_REALITY;
    
    layerMaxX = screenWidth/2 + LIMITS_OF_REALITY;
    layerMaxY = screenHeight/2 + LIMITS_OF_REALITY;
    layerMinX = - LIMITS_OF_REALITY - screenWidth/2;
    layerMinY = - LIMITS_OF_REALITY - screenHeight/2;
    
    screenWidth = agentMaxX - agentMinX;
    screenHeight = agentMaxY - agentMinY;
}

-(void)updateAgent:(PhysicsSprite *)agent{
    
    switch ([Settings getInstance].wt) {
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
    
    if(aX < agentMinX){
        [agent die];
    }
    if(aX > agentMaxX){
        [agent die];
    }
    if(aY < agentMinY){
        [agent die];
    }
    if(aY > agentMaxY){
        [agent die];
    }
}

// World rules for box world
// TODO!!! Make relevant to world position only!!!
-(void) boxWorldAgent:(PhysicsSprite *)agent{
    bool bounced = false;
    if(agent.position.x < agentMinX){
        [agent setPosition:ccp(agentMinX, agent.position.y)];
        [agent setXVel:(fabsf(agent.xVel))];
        bounced = true;
    }
    if(agent.position.x > agentMaxX){
        [agent setPosition:ccp(agentMaxX, agent.position.y)];
        [agent setXVel:(-fabsf(agent.xVel))];
        bounced = true;
    }
    if(agent.position.y < agentMinY){
        [agent setPosition:ccp(agent.position.x, agentMinY)];
        [agent setYVel:(fabsf(agent.yVel))];
        bounced = true;
    }
    if(agent.position.y > agentMaxY){
        [agent setPosition:ccp(agent.position.x, agentMaxY)];
        [agent setYVel:(-fabsf(agent.yVel))];
        bounced = true;
    }
    
    //Remove agents which die at box boundaries
    if(!agent.bounces && bounced){
        [agent die];
    }
}

-(void) directionalWorldAgent:(PhysicsSprite *)agent{
    if(agent.position.y < agentMinY){
        [agent setPosition:ccp(agent.position.x, agentMaxY)];
        [agent setYVel:(-fabsf(agent.yVel))];
    }
    if(agent.position.y > agentMaxY){
        [agent setPosition:ccp(agent.position.x, agentMinY)];
        [agent setYVel:(fabsf(agent.yVel))];
    }
}



-(void)updateLayer:(FocusedLayer *)layer{
    switch ([Settings getInstance].wt) {
        case OPEN:
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


// World rules for box world
// TODO!!! Make relevant to world position only!!!
-(void) boxWorldLayer:(FocusedLayer *)layer{
    CGFloat lX = - layer.position.x;
    CGFloat lY = - layer.position.y;
    
    if(lX < layerMinX){
        [layer setPosition:ccp(- layerMinX, layer.position.y)];
        [layer setXVel:(fabsf(layer.xVel))];
    }
    if(lX > layerMaxX){
        [layer setPosition:ccp(- layerMaxX, layer.position.y)];
        [layer setXVel:(-fabsf(layer.xVel))];
    }
    if(lY < layerMinY){
        [layer setPosition:ccp(layer.position.x, - layerMinY)];
        [layer setYVel:(fabsf(layer.yVel))];
    }
    if(lY > layerMaxY){
        [layer setPosition:ccp(layer.position.x, - layerMaxY)];
        [layer setYVel:(-fabsf(layer.yVel))];
    }
}

-(void) directionalWorldLayer:(FocusedLayer *)layer{
    CGFloat lY = - layer.position.y;
    if(lY < layerMinY){
        [layer setPosition:ccp(layer.position.x, - layerMaxY)];
        [layer setYVel:(-fabsf(layer.yVel))];
    }
    if(lY > layerMaxY){
        [layer setPosition:ccp(layer.position.x, - layerMinY)];
        [layer setYVel:(fabsf(layer.yVel))];
    }
}

@end
