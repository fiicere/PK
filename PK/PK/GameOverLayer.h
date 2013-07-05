//
//  GameOverLayer.h
//  PK
//
//  Created by Kevin Yue on 7/5/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {

}

+(CCScene *) sceneWithScore:(int)score;
- (id)initWithWon:(int)score;

@end
