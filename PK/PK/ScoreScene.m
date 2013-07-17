//
//  ScoreScene.m
//  PK
//
//  Created by Kevin Yue on 7/17/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "ScoreScene.h"
#import "GameOverLayer.h"


@implementation ScoreScene

-(id) init {
    self = [super init];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon] autorelease];
    [self addChild: layer];
    return self;
}

@end
