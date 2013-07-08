//
//  FocusedLayer.m
//  PK
//
//  Created by Kevin Yue on 7/8/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "FocusedLayer.h"
#import "PhysicsSprite.h"


@implementation FocusedLayer

-(id)init{
    printf("ERROR: Cannot create FocusedLayer without a focus!!!");
    return [self initWithFocus:nil];
}

// on "init" you need to initialize your instance
-(id) initWithFocus:(PhysicsSprite*)focus
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        [self setupVariables];
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
	}
    
	return self;
}

-(void) setupVariables:(PhysicsSprite*)focus
{
    _xVel = focus.xVel;
    _yVel = focus.yVel;
}


// Runs every tick
- (void) nextFrame:(ccTime)dt {
    [self setPosition:ccp(self.position.x + (_xVel*dt), self.position.y + (_yVel*dt))];
}



@end
