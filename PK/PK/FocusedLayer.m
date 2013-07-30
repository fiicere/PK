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

-(id)init{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        [self setParallaxFactor:1];
	}
    
	return self;
}

-(void) setFocus:(PhysicsSprite*)f
{
    focus = f;
}


// Runs every tick
- (void) nextFrame:(ccTime)dt {
    if(focus == nil){
        return;
    }
    _xVel = -focus.xVel;
    _yVel = -focus.yVel;
    [self setPosition:ccp(self.position.x + (_xVel*dt*_parallaxFactor), self.position.y + (_yVel*dt*_parallaxFactor))];
    
//    printf("\nxVel = %f", _xVel);
//    printf(", yVel = %f", _yVel);
}



@end
