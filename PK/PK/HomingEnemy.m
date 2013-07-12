//
//  HomingEnemy.m
//  PK
//
//  Created by Kevin Yue on 7/12/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "HomingEnemy.h"
#import "PhysicsSprite.h"

const CGFloat RETARGET_PERIOD = 2;
const CGFloat RETARGET_PAUSE = 1;
const CGFloat HE_SPEED = 500;
NSString* const he_file = @"EnemyB.tif";

@implementation HomingEnemy

-(id) init {
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self = [super initWithFile:he_file])) {
        // schedule a repeating callback on every frame
        [self schedule:@selector(retarget:) interval:RETARGET_PERIOD];
	}
	return self;
}

-(void) retarget{
    CGFloat myX = [self.parent convertToWorldSpace:self.position].x;
    CGFloat myY = [self.parent convertToWorldSpace:self.position].y;
    
    CGFloat destX = self->screenWidth/2;
    CGFloat destY = self->screenHeight/2;
    
    CGFloat dx = destX - myX;
    CGFloat dy = destY - myY;
    CGFloat norm = sqrt(dx*dx+dy*dy);

    self.xVel = HE_SPEED * dx / norm;
    self.yVel = HE_SPEED * dy / norm;

}

@end
