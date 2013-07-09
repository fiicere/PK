//
//  PhysicsSprite.m
//  PK
//
//  Created by Kevin Yue on 7/8/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "PhysicsSprite.h"


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

// Variable Setup
-(void) setupVariables{
    _xVel = 0;
    _yVel = 0;
}

// On-Tick Event
// Runs every tick
- (void) onTick:(ccTime)dt {
    [self setPosition:ccp(self.position.x + (_xVel*dt), self.position.y + (_yVel*dt))];
}



@end
