//
//  HomingEnemy.m
//  PK
//
//  Created by Kevin Yue on 7/12/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "HomingEnemy.h"
#import "PhysicsSprite.h"
#import "RandomTrajectory.h"
#import "GameScene.h"

const ccTime RETARGET_PERIOD = 2;
const ccTime RETARGET_PAUSE = .5;
const CGFloat HE_DAMAGE = 75;
const CGFloat HE_HEALTH = 100;
const CGFloat HE_VALUE = 1;
const CGFloat HE_SPEED = 400;
const bool HE_BOUNCES = true;

NSString* const he_file = @"EnemyC.tif";

@implementation HomingEnemy

-(id) init {
    self = [super initWithFile:he_file];
    if(self){
        // schedule a repeating callback on every frame
        [self schedule:@selector(retarget:) interval:RETARGET_PERIOD];
        [self setStatsHP:HE_HEALTH DMG:HE_DAMAGE POINTS:HE_VALUE BOUNCES:HE_BOUNCES];
        [self setStartingStats];
    }
	return self;
}

-(void) retarget:(ccTime)dt{
    
    CGFloat myX = [self.parent convertToWorldSpace:self.position].x;
    CGFloat myY = [self.parent convertToWorldSpace:self.position].y;
    
    CGFloat destX = self->screenWidth/2;
    CGFloat destY = self->screenHeight/2;
    
    CGFloat dx = destX - myX;
    CGFloat dy = destY - myY;
    CGFloat norm = sqrt(dx*dx+dy*dy);
    
    
    [self setXVel:(HE_SPEED * dx / norm) YVel:(HE_SPEED * dy / norm)];
    
    [self pause];
}

-(void)pause{
    [self setFixedPosition:true];
    [self performSelector:@selector(resume) withObject:nil afterDelay:RETARGET_PAUSE];
}

-(void)resume{
    [self setFixedPosition:false];
}


-(CGFloat) getSpeed{
    return HE_SPEED;
}

-(void) setStartingStats{
    RandomTrajectory *t = [[RandomTrajectory alloc] init];
    
    self.position = ccp(t.startX - [GameScene getEL].position.x, t.startY - [GameScene getEL].position.y);
    
    [self pushWithXForce:t.trajdX*self.getSpeed/t.norm YForce:t.trajdY*self.getSpeed/t.norm];
    [t dealloc];
}

@end
