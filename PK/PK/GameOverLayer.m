//
//  GameOverLayer.m
//  PK
//
//  Created by Kevin Yue on 7/5/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"


@implementation GameOverLayer
+(CCScene *) sceneWithScore:(int)score {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:score] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(int)score {
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        
        NSString * message = [NSString stringWithFormat:@"Game Over: \nFinal Score ", score];

        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(0,0,0);
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
    return self;
}
@end
