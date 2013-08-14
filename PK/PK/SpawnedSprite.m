//
//  SpawnedSprites.m
//  PK
//
//  Created by Kevin Yue on 8/12/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "cocos2d.h"
#import "SpawnedSprite.h"
#import "GameScene.h"
#import "Clock.h"
#import "Settings.h"

static CGFloat spawnRate = 0;
static CGFloat startingSpawnTime = 0;
const CGFloat PRECISION = 1000;
const CGFloat DIFFICULTY_RAMP = 30;

@implementation SpawnedSprite

-(id) initWithFile:(NSString*) filename{
    self = [super initWithFile:filename];
    [self schedule: @selector(moveToEL:) interval: 1.0f];
    [self runAction:[CCFadeIn actionWithDuration:1.0f]];
    self.fixedPosition = true;
    return self;
}

+(void)spawnEnemies:(ccTime)dt{
    // Check if should be spawning
    if([Clock getInstance].getTime < [self getSST]){
        return;
    }
    // Otherwise spawn enemies proportional to the # of players
    else{
        for(int i=0; i<[self dangerLevel]; i++){
            int thresh = fmod(arc4random(), ([self getSR] * PRECISION));
            if (thresh < dt * PRECISION){                
                [[GameScene getHUDL] addChild:[[[self alloc] init] autorelease]];
            }
        }
    }
}


// Returns a integer representing how hard the game is
+(int)dangerLevel{
    int numPlayers = [Settings getInstance].numPlayers;
    int gameScaling = (int)([Clock getInstance].getTime / DIFFICULTY_RAMP);
    return numPlayers + gameScaling;
}

+(CGFloat)getSR{
    return spawnRate;
}

+(CGFloat)getSST{
    return startingSpawnTime;
}


-(void)moveToEL:(ccTime)dt{
    [self unschedule: @selector(moveToEL:)];
    [[self parent] removeChild:self cleanup:NO];
    [[GameScene getEL] addChild:self];
    self.fixedPosition = false;
}


@end
