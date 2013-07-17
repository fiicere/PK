//
//  WorldBoundaries.m
//  PK
//
//  Created by Kevin Yue on 7/16/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import "WorldBoundaries.h"
#import "PhysicsSprite.h"

const CGFloat LIMITS_OF_REALITY = 1000;

static WorldBoundaries *instance;

enum worldType wt = OPEN;

// World info
CGFloat screenWidth;
CGFloat screenHeight;
CGFloat realityMinX;
CGFloat realityMinY;
CGFloat realityMaxX;
CGFloat realityMaxY;

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
}

-(void)updateAgent:(PhysicsSprite *)agent{
    
    switch (wt) {
        case OPEN:
            [self openWorld:agent];
            break;
        case BOX:
            [self boxWorld:agent];
            break;
        case DIRECTIONAL:
            [self directionalWorld:agent];
            break;
        default:
            break;
    }
}

// World rules for open world
-(void) openWorld:(PhysicsSprite *)agent{
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
-(void) boxWorld:(PhysicsSprite *)agent{
    CGFloat aX = [agent.parent convertToWorldSpace:agent.position].x;
    CGFloat aY = [agent.parent convertToWorldSpace:agent.position].y;
    
    if(aX < realityMinX){
        [agent setPosition:ccp(realityMinX, agent.position.y)];
        [agent setXVel:(-agent.xVel)];
    }
    if(aX > realityMaxX){
        [agent setPosition:ccp(realityMaxX, agent.position.y)];
        [agent setXVel:(-agent.xVel)];
    }
    if(aY < realityMinY){
        [agent setPosition:ccp(agent.position.x, realityMinY)];
        [agent setXVel:(-agent.yVel)];
    }
    if(aY > realityMaxY){
        [agent setPosition:ccp(agent.position.x, realityMaxY)];
        [agent setXVel:(-agent.yVel)];

    }
}

-(void) directionalWorld:(PhysicsSprite *)agent{
    //TODO
}

@end
