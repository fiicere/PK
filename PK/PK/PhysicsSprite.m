//
//  PhysicsSprite.m
//  PK
//
//  Created by Kevin Yue on 7/8/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "PhysicsSprite.h"
#import "ScoreKeeper.h"
#import "RandomTrajectory.h"
#import "WorldBoundaries.h"

// Constants
const CGFloat FRICTION = .02;
const CGFloat COLLISION_OVERLAP = .8;
const bool debug = true;

// My info
const CGFloat maxHP = 100;
const CGFloat baseDMG = 100;

// World info
CGFloat screenWidth;
CGFloat screenHeight;
CGFloat agentMinX;
CGFloat agentMinY;
CGFloat agentMaxX;
CGFloat agentMaxY;

@implementation PhysicsSprite

// Init Method
-(id) init {
//	// always call "super" init
//	// Apple recommends to re-assign "self" with the "super's" return value
//	if( (self=[super init]) ) {
//        [self setupVariables];
//        
//        // schedule a repeating callback on every frame
//        [self schedule:@selector(onTick:)];
//	}
	return self;
}

-(id) initWithFile:(NSString*) filename{
    self = [super initWithFile:filename];
    [self setupVariables];
    [self schedule:@selector(onTick:)];
    return self;
}


// Variable Setup
-(void) setupVariables{
    _xVel = 0;
    _yVel = 0;
    screenHeight = CCDirector.sharedDirector.winSize.height;
    screenWidth = CCDirector.sharedDirector.winSize.width;
}

-(void) setStatsHP:(CGFloat)hp DMG:(CGFloat)dmg POINTS:(CGFloat)value BOUNCES:(bool)doesBounce{
    [self setHealth:hp];
    [self setDamage:dmg];
    [self setPoints:value];
    [self setBounces:doesBounce];
    }

// Scale down the velocity
-(void) scaleVel:(CGFloat)scale{
    _xVel *= scale;
    _yVel *= scale;
}

// Add to current velocity
- (void) pushWithXForce:(CGFloat)dX YForce:(CGFloat)dY{
    _xVel += dX;
    _yVel += dY;
}

// Set the velocity
- (void) setXVel:(CGFloat)xV YVel:(CGFloat)yV{
    _xVel = xV;
    _yVel = yV;
}

// On-Tick Event
// TODO: Find why this runs twice per tick
- (void) onTick:(ccTime)dt {
    // Apply friction
    if (_hasFrict){
        [self scaleVel:(1-FRICTION)];
    }
    
    // If the position is not fixed, update location
    if(!_fixedPosition){
        [self setPosition:ccp(self.position.x + (_xVel*dt), self.position.y + (_yVel*dt))];
    }
    [[WorldBoundaries getInstance] updateAgent:self];

    [self checkDeath];
}

// Die if you go too far off screen
- (void) checkDeath{
    if(_health <= 0){
        [[ScoreKeeper getInstance] incScore:_points];
        [self die];
    }
    
}

// Returns world-frame bounding box
-(CGRect) getBoundingBox{
    CGFloat myX = [self.parent convertToWorldSpace:self.position].x;
    CGFloat myY = [self.parent convertToWorldSpace:self.position].y;
    
    CGFloat width = self.boundingBox.size.width * COLLISION_OVERLAP;
    CGFloat height = self.boundingBox.size.height * COLLISION_OVERLAP;

    CGRect myBox = CGRectMake(myX - width/2, myY-height/2, width, height);
    return myBox;
}

// Remove agent
- (void) die{
    [self.parent removeChild:self cleanup:YES];
}

@end
