//
//  PhysicsSprite.m
//  PK
//
//  Created by Kevin Yue on 7/8/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "PhysicsSprite.h"

const CGFloat FRICTION = .02;

bool fixedPos = false;
bool hasFrict = false;

@implementation PhysicsSprite

// Init Method
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        [self setupVariables];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(onTick:)];
	}
	return self;
}

-(PhysicsSprite*) createWithFile:(NSString*) filename{
    self = [super initWithFile:filename];
    [self setupVariables];
    [self schedule:@selector(onTick:)];
    return self;
}

// Variable Setup
-(void) setupVariables{
    _xVel = 0;
    _yVel = 0;
}

// Fix the position of this agent
-(void) fixPosition:(bool)fixed{
    fixedPos = fixed;
}

// Toggle the friction of the agent
-(void) toggleFrict:(bool)friction{
    hasFrict = friction;
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
// Runs every tick
- (void) onTick:(ccTime)dt {
    // Apply friction
    if (hasFrict){
        [self scaleVel:(1-FRICTION)];
    }
    
    // If the position is not fixed, update location
    if(!fixedPos){
        [self setPosition:ccp(self.position.x + (_xVel*dt), self.position.y + (_yVel*dt))];        
    }
}



@end
