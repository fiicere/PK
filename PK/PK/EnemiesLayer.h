//
//  EnemiesLayer.h
//  PK
//
//  Created by Kevin Yue on 7/5/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnemiesLayer : CCLayer {
}
@property (nonatomic, assign) CGFloat xVel;
@property (nonatomic, assign) CGFloat yVel;

-(void)shotFired:(CGPoint)loc;


@end
