//
//  PlayerShip.m
//  PK
//
//  Created by Kevin Yue on 7/16/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "PlayerShip.h"
#import "PhysicsSprite.h"
#import "GameOverLayer.h"
#import "HelloWorldLayer.h"

const CGFloat PS_HP = 99;
const CGFloat PS_DMG = 1000;
const CGFloat PS_VAL = 0;
const bool PS_BOUNCES = TRUE;
bool isHit = FALSE;

NSString* const PS_FILE = @"Ship.tif";

CCSprite* hp1;
CCSprite* hp2;
CCSprite* hp3;

@implementation PlayerShip

-(id) init {
    self = [super initWithFile:PS_FILE];
    if(self){
        [self setStatsHP:PS_HP DMG:PS_DMG POINTS:PS_VAL BOUNCES:PS_BOUNCES];
        
        id rotate = [CCRotateBy actionWithDuration:3 angle:360];
		id action = [CCRepeatForever actionWithAction:rotate];
        hp1 = [CCSprite spriteWithFile:@"ShipHealth.tif"];
        hp2 = [CCSprite spriteWithFile:@"ShipHealth.tif"];
        hp3 = [CCSprite spriteWithFile:@"ShipHealth.tif"];
        
        hp1.position = ccp(self.position.x + 64.0f, self.position.y + 64.0f);
        hp2.position = ccp(self.position.x + 64.0f, self.position.y + 64.0f);
        hp3.position = ccp(self.position.x + 64.0f, self.position.y + 64.0f);
        
        hp1.anchorPoint = ccp(0.5f, 1.75f);
        hp2.anchorPoint = ccp(0.5f + 1.25f*0.866025f, 0.5f - 1.25f*0.5f);
        hp3.anchorPoint = ccp(0.5f - 1.25f*0.866025f, 0.5f - 1.25f*0.5f);
        
        id copy = [[action copy] autorelease];
        id copy2 = [[action copy] autorelease];
        [hp1 runAction:action];
        [hp2 runAction:copy];
        [hp3 runAction:copy2];
        [self addChild:hp1 z:3];
        [self addChild:hp2 z:3];
        [self addChild:hp3 z:3];
        
        
    }
	return self;
}

-(void) hitWithDamage:(CGFloat)damage {
//    id hit = [CCTintBy actionWithDuration:0.2 red:0 green:255 blue:255];
    id multihit = [CCSequence actions: [CCTintBy actionWithDuration:0.5 red:0 green:255 blue:255],
                   [CCTintBy actionWithDuration:0.5 red:0 green:255 blue:255],
                   [CCTintBy actionWithDuration:0.5 red:0 green:255 blue:255], nil];
    
    CGFloat newhp = self.health - damage;
    
    if (self.health <= 1) {
        [self die];
    }
    
    if (self.health > 66) {
        if ( newhp <= 66) {
            [self removeChild:hp1 cleanup:YES];
            self.health = 66;
        }
        else {
            if (!isHit) {
                isHit = TRUE;
                [hp1 runAction:multihit];
                self.health = newhp;
                isHit = FALSE;
            }
        }
    }
    
    if (33 < self.health <= 66) {
        if (newhp <= 33) {
            [self removeChild:hp2 cleanup:YES];
            self.health = 33;
        }
        else {
            if (!isHit) {
                isHit = TRUE;
                [hp2 runAction:multihit];
                self.health = newhp;
                isHit = FALSE;
            }
        }
    }
    
    if (1 < self.health <= 33) {
        if (newhp <= 1) {
            [self removeChild:hp3 cleanup:YES];
            self.health = 1;
        }
        else {
            if (!isHit) {
                isHit = TRUE;
                [hp3 runAction:multihit];
                self.health = newhp;
                isHit = FALSE;
            }

        }
    }
}

//-(void) hitAnimation {
//    id hit;
//    hit = [CCTintBy actionWithDuration:0.2 red:255 green:-255 blue:-255];
//    id afterHit = [CCTintBy actionWithDuration:0.1 red:-255 green:255 blue:255];
//    
//    if (self.health > 66) {
//        [hp1 runAction:hit];
//        [hp1 runAction:afterHit];
//    }
//    else if (33 < self.health <= 66){
//        [self removeChild:hp1 cleanup:YES];
//        [hp2 runAction:hit];
//        [hp2 runAction:afterHit];
//    }
//    else if (1 < self.health <= 33) {
//        [self removeChild:hp2 cleanup:YES];
//        [hp3 runAction:hit];
//        [hp3 runAction:afterHit];
//    }
//    else {
//        [self removeChild:hp3 cleanup:YES];
//    }
//}

@end
