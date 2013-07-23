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
    
    CCLabelTTF * open = [CCLabelTTF labelWithString:@"Play Game With Open World" fontName:@"Arial" fontSize:32];
    CCLabelTTF * box = [CCLabelTTF labelWithString:@"Play Game With Box World" fontName:@"Arial" fontSize:32];
    CCLabelTTF * cylinder = [CCLabelTTF labelWithString:@"Play Game With Cylindrical World" fontName:@"Arial" fontSize:32];
    
    CCMenuItem *startOpenGameButton = [CCMenuItemLabel itemWithLabel:open
                                                                target:self selector:@selector(startOpenGame)];
    CCMenuItem *startBoxGameButton = [CCMenuItemLabel itemWithLabel:box
                                                                    target:self selector:@selector(startBoxGame)];
    CCMenuItem *startDirectionalGameButton = [CCMenuItemLabel itemWithLabel:cylinder
                                                                    target:self selector:@selector(startDirectionalGame)];
    
    [menu addChild:startOpenGameButton];
    [menu addChild:startBoxGameButton];
    [menu addChild:startDirectionalGameButton];
    [menu alignItemsVerticallyWithPadding:32.0f];
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
