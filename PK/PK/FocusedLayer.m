//
//  FocusedLayer.m
//  PK
//
//  Created by Kevin Yue on 7/8/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "FocusedLayer.h"
#import "PhysicsSprite.h"

PhysicsSprite *focus;


@implementation FocusedLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        // schedule a repeating callback on every frame
        [self schedule:@selector(onTick:)];
	}
	return self;
}

// Sets the FocusedLayer to follow agent
-(void) setFocus:(PhysicsSprite*) newFocus{
    focus = newFocus;
}

// Runs every tick
- (void) onTick:(ccTime)dt {
    if (focus == nil) {
        return;
    }
    _xVel = - focus.xVel;
    _yVel = - focus.yVel;
    [self setPosition:ccp(self.position.x + (_xVel*dt), self.position.y + (_yVel*dt))];
}



@end
