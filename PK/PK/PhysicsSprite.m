//
//  PhysicsSprite.m
//  PK
//
//  Created by Kevin Yue on 7/8/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "PhysicsSprite.h"

// Constants
const CGFloat FRICTION = .02;
const CGFloat LIMITS_OF_REALITY = 500;
const CGFloat COLLISION_OVERLAP = 1.3;
const bool debug = true;

// My info
CGFloat myWidth;
CGFloat myHeight;


// World info
CGFloat screenWidth;
CGFloat screenHeight;
CGFloat realityMinX;
CGFloat realityMinY;
CGFloat realityMaxX;
CGFloat realityMaxY;

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
    screenHeight = CCDirector.sharedDirector.winSize.height;
    screenWidth = CCDirector.sharedDirector.winSize.width;
    realityMaxX = screenWidth + LIMITS_OF_REALITY;
    realityMaxY = screenHeight + LIMITS_OF_REALITY;
    realityMinX = - LIMITS_OF_REALITY;
    realityMinY = - LIMITS_OF_REALITY;
    myWidth = self.boundingBox.size.width;
    myHeight = self.boundingBox.size.height;
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
    if (_hasFrict){
        [self scaleVel:(1-FRICTION)];
    }
    
    // If the position is not fixed, update location
    if(!_fixedPosition){
        [self setPosition:ccp(self.position.x + (_xVel*dt), self.position.y + (_yVel*dt))];
        [self checkDeath];
    }
}


// Die if you go too far off screen
- (void) checkDeath{
    CGFloat myX = [self.parent convertToWorldSpace:self.position].x;
    CGFloat myY = [self.parent convertToWorldSpace:self.position].y;

    if(myX < realityMinX){
        [self die];
    }
    if(myX > realityMaxX){
        [self die];
    }
    if(myY < realityMinY){
        [self die];
    }
    if(myY > realityMaxY){
        [self die];
    }
}

// Returns world-frame bounding box
-(CGRect) getBoundingBox{
    CGFloat myX = [self.parent convertToWorldSpace:self.position].x;
    CGFloat myY = [self.parent convertToWorldSpace:self.position].y;

    CGRect myBox = CGRectMake(myX, myY, myWidth*COLLISION_OVERLAP, myHeight*COLLISION_OVERLAP);
    return myBox;
}

// Remove agent
- (void) die{
    [self.parent removeChild:self cleanup:YES];
}

@end
