//
//  BackgroundLayer.m
//  PK
//
//  Created by Kevin Yue on 7/11/13.
//  Copyright 2013 Kevin Yue. All rights reserved.
//

#import "BackgroundLayer.h"
#import "FocusedLayer.h"

CCSprite *defaultSprite;
CGFloat tileWidth;
CGFloat tileHeight;

NSString* const file = @"TempSpace.jpg";

CGPoint nearestIntersection;

@implementation BackgroundLayer

-(id)init{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        // schedule a repeating callback on every frame
        [self setupVariables];
	}
    
	return self;
}

-(void) setupVariables{
    defaultSprite = [CCSprite spriteWithFile:@"TempSpace.jpg"];
    tileWidth = defaultSprite.boundingBox.size.width;
    tileHeight = defaultSprite.boundingBox.size.height;
    [self newBackground];
}

// Runs every tick
- (void) nextFrame:(ccTime)dt {
    if(focus == nil){
        return;
    }
    [self updatePosition:dt];
    [self updateTile];
}

- (void) updatePosition:(ccTime)dt{
    self.xVel = -focus.xVel;
    self.yVel = -focus.yVel;
    [self setPosition:ccp(self.position.x + (self.xVel*dt), self.position.y + (self.yVel*dt))];
}


-(void) updateTile{
    CGPoint newInt = [self getIntersect];
    
    if (!CGPointEqualToPoint(newInt, nearestIntersection)){
        [self newBackground];
    }
}

-(void) newBackground{
    [self removeAllChildrenWithCleanup:YES];
    
    CGPoint intersec = [self getIntersect];
    
    CGFloat myX = intersec.x;
    CGFloat myY = intersec.y;
    
    CCSprite *spriteA = [CCSprite spriteWithFile:file];
    CCSprite *spriteB = [CCSprite spriteWithFile:file];
    CCSprite *spriteC = [CCSprite spriteWithFile:file];
    CCSprite *spriteD = [CCSprite spriteWithFile:file];
    
    [spriteA setPosition:ccp(myX + tileWidth/2, myY + tileHeight/2)];
    [spriteB setPosition:ccp(myX + tileWidth*3/2, myY + tileHeight/2)];
    [spriteC setPosition:ccp(myX+ tileWidth/2, myY + tileHeight *3/2)];
    [spriteD setPosition:ccp(myX + tileWidth*3/2, myY + tileHeight*3/2)];
    
    [self addChild:spriteA];
    [self addChild:spriteB];
    [self addChild:spriteC];
    [self addChild:spriteD];
}

- (CGPoint) getIntersect{
    CGFloat x = - self.position.x / (tileWidth);
    CGFloat y = - self.position.y / (tileHeight);
    
    x = floorf(x);
    y = floorf(y);
    
    x *= tileWidth;
    y *= tileHeight;
    
    return ccp(x,y);
}



@end