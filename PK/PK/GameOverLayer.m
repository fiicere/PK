//
//  GameOverLayer.m
//  PK
//
//  Created by Kevin Yue on 7/5/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"
#import "ScoreKeeper.h"


@implementation GameOverLayer
+(CCScene *) sceneWithScore {
    printf("\nNew scene");
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon] autorelease];
    [scene addChild: layer];
    printf("\nfinished creating new scene");
    return scene;
}

- (id)initWithWon{
    printf("\nGame over layer");
    if ((self = [super initWithColor:ccc4(0, 0, 0, 255)])) {
        
        printf("\nbefore get score");
        int score = [[ScoreKeeper getInstance] getScore];
        printf("\nafter get score");

        NSString * message = [NSString stringWithFormat:@"Game Over: \nFinal Score = %d", score];

        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(255,255,255);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:2],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
         }],
          nil]];
    }
    printf("\nfinished creating game over layer");
    return self;
}
@end
