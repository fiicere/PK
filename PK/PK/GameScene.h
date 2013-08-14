//
//  GameScene.h
//  PK
//
//  Created by Kevin Yue on 7/17/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FocusedLayer.h"
#import "BackgroundLayer.h"
#import "HelloWorldLayer.h"

@interface GameScene : CCScene {
}

+(FocusedLayer*)getEL;

+(FocusedLayer*)getEPL;

+(FocusedLayer*)getPL;

+(BackgroundLayer*)getBL;

+(BackgroundLayer*)getBL2;

+(FocusedLayer*)getGL;

+(HelloWorldLayer*)getSL;

+(FocusedLayer*)getWoDL;

+(FocusedLayer*)getHUDL;


@end
