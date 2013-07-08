//
//  PhysicsSprite.m
//  PK
//
//  Created by Kevin Yue on 7/8/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "PhysicsSprite.h"

bool fixedPosition = false;
bool hasFriction = false;
const CGFloat FRICTION = .01;

@implementation PhysicsSprite

// Init Method
-(id) init{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        [self setupVariables];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(onTick:)];
	}
	return self;
}

// Variable Setup
-(void) setupVariables{
    _xVel = 0;
    _yVel = 0;
    fixedPosition = false;
    hasFriction = false;
}

// Fixes the sprite in position
-(void)fixPosition{
    fixedPosition = true;
}

// Fixes the sprite in position
-(void)setFriction:(bool)frict{
    hasFriction = frict;
}

// On-Tick Event
// Runs every tick
- (void) onTick:(ccTime)dt {
    // Friction
    if(hasFriction){
        _xVel *= (1-FRICTION);
        _yVel *= (1-FRICTION);
    }
    
    // Update position if not fixed
    if(! fixedPosition){
        [self setPosition:ccp(self.position.x + (_xVel*dt), self.position.y + (_yVel*dt))];
    }
}


// Sets the sprite's velocity
-(void)setVelocitydX:(CGFloat)newXVel dY:(CGFloat)newYVel{
    _xVel = newXVel;
    _yVel = newYVel;
}

// Increments the sprite's velocity
-(void)incVelocitydX:(CGFloat)dX dy:(CGFloat)dY{
    _xVel += dX;
    _yVel += dY;
}

@end
