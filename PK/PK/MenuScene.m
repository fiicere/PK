//
//  MenuScene.m
//  PK
//
//  Created by PHILLIP SEO on 7/23/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

static CCLayer *ml;


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
    
    CCMenuItem *startGameButton = [CCMenuItemImage itemWithNormalImage:@"Shot.tif" selectedImage:@"EnemyA.tif"
                                                                target:self selector:@selector(startGame)];
    [menu addChild:startGameButton];
    [menuLayer addChild:menu];
}

-(void) startGame {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[GameScene alloc] init] ]];
}

@end
