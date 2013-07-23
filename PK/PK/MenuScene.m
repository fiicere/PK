//
//  MenuScene.m
//  PK
//
//  Created by PHILLIP SEO on 7/23/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "WorldBoundaries.h"

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
    
    CCMenuItem *startOpenGameButton = [CCMenuItemImage itemWithNormalImage:@"Shot.tif" selectedImage:@"Shot.tif"
                                                                target:self selector:@selector(startOpenGame)];
    CCMenuItem *startBoxGameButton = [CCMenuItemImage itemWithNormalImage:@"EnemyA.tif" selectedImage:@"EnemyA.tif"
                                                                    target:self selector:@selector(startBoxGame)];
    CCMenuItem *startDirectionalGameButton = [CCMenuItemImage itemWithNormalImage:@"EnemyB.tif" selectedImage:@"EnemyB.tif"
                                                                    target:self selector:@selector(startDirectionalGame)];
    
    [menu addChild:startOpenGameButton];
    [menu addChild:startBoxGameButton];
    [menu addChild:startDirectionalGameButton];
    [menu alignItemsHorizontally];
    [menuLayer addChild:menu];
}

-(void) startOpenGame {
    [[WorldBoundaries getInstance] setWorldType:OPEN];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[GameScene alloc] init] ]];
}

-(void) startBoxGame {
    [[WorldBoundaries getInstance] setWorldType:BOX];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[GameScene alloc] init] ]];
}

-(void) startDirectionalGame {
    [[WorldBoundaries getInstance] setWorldType:DIRECTIONAL];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[GameScene alloc] init] ]];
}

@end
