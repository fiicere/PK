//
//  Trajectory.m
//  PK
//
//  Created by Kevin Yue on 7/12/13.
//  Copyright (c) 2013 Kevin Yue. All rights reserved.
//

#import "RandomTrajectory.h"
#import "CCDirector.h"

CGFloat screenWidth;
CGFloat screenHeight;

CGFloat const r = 100;

@implementation RandomTrajectory

-(id)init{
    [self setupVariables];
    [self calculateTrajectory];
    
    self = [super init];
	return self;
}

-(void) setupVariables{
    screenHeight = CCDirector.sharedDirector.winSize.height;
    screenWidth = CCDirector.sharedDirector.winSize.width;
}

-(void)calculateTrajectory{
    // UFO's starting and ending coords

    
    // Randomly choose where the UFO enters from
    int rand = arc4random() % 4;
    
    switch (rand) {
        case 0:
            // Right to left movement
            _startY = fmod((CGFloat)arc4random(), screenHeight);
            _startX = screenWidth + r;
            _endY = fmod((CGFloat)arc4random(), screenHeight);
            _endX = -r;
            break;
        case 1:
            // Left to right movement
            _startY = fmod((CGFloat)arc4random(), screenHeight);
            _startX = -r;
            _endY = fmod((CGFloat)arc4random(), screenHeight);
            _endX = screenWidth + r;
            break;
        case 2:
            // Top down movement
            _startY = screenHeight + r;
            _startX = fmod((CGFloat) arc4random(), screenWidth);
            _endY = -r;
            _endX = fmod((CGFloat) arc4random(), screenWidth);
            break;
        case 3:
            // Down up movement
            _startY = -r;
            _startX = fmod((CGFloat) arc4random(), screenWidth);
            _endY = screenHeight+r;
            _endX = fmod((CGFloat) arc4random(), screenWidth);
            break;
        default:
            printf("WTF?");
            break;
    }
        
    _trajdX = _endX - _startX;
    _trajdY = _endY - _startY;
    _norm = sqrt(_trajdX*_trajdX + _trajdY*_trajdY);

}

@end
