//
//  Turret.m
//  PK
//
//  Created by Kevin Yue on 7/16/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "Turret.h"
#import "PhysicsSprite.h"
#import "TurretShot.h"
#import "GameScene.h"

const CGFloat T_HP = 100;
const CGFloat T_DMG = 100;
const CGFloat T_VAL = 2;

const CGFloat FIRE_RATE = .5;
const CGFloat BULLET_SPEED = 500;

const CGFloat TUR_SPEED = 200;


NSString* const T_FILE = @"EnemyB.tif";

@implementation Turret
-(id) init {
    self = [super initWithFile:T_FILE];
    if(self){
        [self setStatsHP:T_HP DMG:T_DMG POINTS:T_VAL];
        [self schedule:@selector(fire:) interval:FIRE_RATE];
    }
	return self;
}


-(void)fire:(ccTime)dt{
    CGFloat myX = [self.parent convertToWorldSpace:self.position].x;
    CGFloat myY = [self.parent convertToWorldSpace:self.position].y;
    
    CGFloat destX = self->screenWidth/2;
    CGFloat destY = self->screenHeight/2;
    
    CGFloat dx = destX - myX;
    CGFloat dy = destY - myY;
    CGFloat norm = sqrt(dx*dx+dy*dy);
    
    TurretShot *ts = [[TurretShot alloc] init];
    ts.position = self.position;
    [ts setXVel:(BULLET_SPEED * dx / norm) YVel:(BULLET_SPEED * dy / norm)];
    [[GameScene getEPL] addChild:ts];

}

-(CGFloat) getSpeed{
    return TUR_SPEED;
}
@end
