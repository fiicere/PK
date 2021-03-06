//
//  EnemiesLayer.m
//  PK
//
//  Created by Kevin Yue on 7/5/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "EnemiesLayer.h"

CGFloat height;
CGFloat width;


//const CGFloat FRICTION = .01;
//const CGFloat BULLETFORCE = 1.5;

@implementation EnemiesLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        [self setupVariables];
        [self scheduleEvents];
        
        // to enable touch detection
        self.isTouchEnabled = YES;
        
	}
    
	return self;
}

// Initialize all variables
-(void) setupVariables
{
    height = CCDirector.sharedDirector.winSize.height;
    width = CCDirector.sharedDirector.winSize.width;
    _xVel = 0;
    _yVel = 0;
}

// Schedule all events
-(void) scheduleEvents
{
    // per-tick timer
    [self schedule:@selector(onTickEvents:)];
    // 1 second timer
    [self schedule:@selector(perSecondEvents:) interval:1.0];
}

// Runs every second
-(void)perSecondEvents:(ccTime)dt{
}


//
//// Runs every tick
//- (void) onTickEvents:(ccTime)dt {
//    _xVel *= (1-FRICTION);
//    _yVel *= (1-FRICTION);
//}
//
//-(void) shotFired:(CGPoint) loc{
//    CGPoint offset = ccpSub(loc, ccp(width/2, height/2));
//    
//    _xVel += BULLETFORCE * offset.x/sqrt(offset.x * offset.x + offset.y*offset.y);
//    _yVel += BULLETFORCE * offset.y/sqrt(offset.x * offset.x + offset.y*offset.y);
//}

@end
