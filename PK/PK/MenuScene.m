//
//  MenuScene.m
//  PK
//
//  Created by PHILLIP SEO on 7/23/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "Settings.h"

static CCLayer *ml;
bool hasType = false;
bool hasNumPlayers = false;


@implementation MenuScene

-(id) init {
    self = [super init];
    
    ml = [CCLayer node];
    
    [self SetUpMenu:ml];
    
    [self addChild:ml];
    return self;
}

-(void) SetUpMenu:(CCLayer*) menuLayer {
    CCMenu *menu = [CCMenu menuWithItems:nil];
    
    // Game Mode Labels
    CCLabelTTF * open = [CCLabelTTF labelWithString:@"Open World Game" fontName:@"Arial" fontSize:32];
    CCLabelTTF * box = [CCLabelTTF labelWithString:@"Box World Game" fontName:@"Arial" fontSize:32];
    CCLabelTTF * cylinder = [CCLabelTTF labelWithString:@"Cylindrical World Game" fontName:@"Arial" fontSize:32];
    
    CCMenuItem *startOpenGameButton = [CCMenuItemLabel itemWithLabel:open
                                                                target:self selector:@selector(startOpenGame)];
    CCMenuItem *startBoxGameButton = [CCMenuItemLabel itemWithLabel:box
                                                                    target:self selector:@selector(startBoxGame)];
    CCMenuItem *startDirectionalGameButton = [CCMenuItemLabel itemWithLabel:cylinder
                                                                    target:self selector:@selector(startDirectionalGame)];
    
    // Number of Player Labels
    CCLabelTTF * onep = [CCLabelTTF labelWithString:@"with 1 player" fontName:@"Arial" fontSize:32];
    CCLabelTTF * twop = [CCLabelTTF labelWithString:@"with 2 players" fontName:@"Arial" fontSize:32];
    CCLabelTTF * threep = [CCLabelTTF labelWithString:@"with 3 players" fontName:@"Arial" fontSize:32];
    
    CCMenuItem *start1p = [CCMenuItemLabel itemWithLabel:onep
                                                              target:self selector:@selector(onePlayer)];
    CCMenuItem *start2p = [CCMenuItemLabel itemWithLabel:twop
                                                             target:self selector:@selector(twoPlayer)];
    CCMenuItem *start3p = [CCMenuItemLabel itemWithLabel:threep
                                                                     target:self selector:@selector(threePlayer)];

    
    [menu addChild:startOpenGameButton];
    [menu addChild:startBoxGameButton];
    [menu addChild:startDirectionalGameButton];
    [menu addChild:start1p];
    [menu addChild:start2p];
    [menu addChild:start3p];
    [menu alignItemsVerticallyWithPadding:32.0f];
    [menuLayer addChild:menu];
    
    
    // Timer
    [self schedule:@selector(checkStart:)];
}


-(void) startOpenGame {
    [Settings getInstance].wt = OPEN;
    hasType = true;
}

-(void) startBoxGame {
    [Settings getInstance].wt = BOX;
    hasType = true;
}

-(void) startDirectionalGame {
    [Settings getInstance].wt = DIRECTIONAL;
    hasType = true;

}


-(void) onePlayer {
    [Settings getInstance].numPlayers = 1;
    hasNumPlayers = true;
}

-(void) twoPlayer {
    [Settings getInstance].numPlayers = 2;
    hasNumPlayers = true;
    
}

-(void) threePlayer {
    [Settings getInstance].numPlayers = 3;
    hasNumPlayers = true;
}


-(void)checkStart:(ccTime)dt{
    if(hasType && hasNumPlayers){
        hasType = false;
        hasNumPlayers = false;
        [self startGame];
    }
}


-(void)startGame{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[GameScene alloc] init] ]];
    
}


@end
