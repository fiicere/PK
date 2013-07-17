//
//  HelloWorldLayer.h
//  PK
//
//  Created by Kevin Yue on 7/1/13.
//  Copyright Kevin Yue 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "FocusedLayer.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

@end
