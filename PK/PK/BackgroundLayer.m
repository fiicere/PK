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

NSString* background_file;

CGPoint nearestIntersection;

@implementation BackgroundLayer

-(id)init{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
//	if( (self=[super init]) ) {
        // schedule a repeating callback on every frame
//        [self setupVariables];
//	}
    
	return self;
}

-(id) initWithFile:(NSString*)filename{
    [super init];
    defaultSprite = [CCSprite spriteWithFile:filename];
    background_file = filename;
    [self setupVariables];
    //[self schedule:@selector(nextFrame:)];
    return self;
}

-(void) setupVariables{
    //defaultSprite = [CCSprite spriteWithFile:@"Stars 2048x1536.tif"];
    tileWidth = defaultSprite.boundingBox.size.width;
    tileHeight = defaultSprite.boundingBox.size.height;
    [self newBackground];
}

// Runs every tick
- (void) nextFrame:(ccTime)dt {
    if(focus == nil){
        return;
    }
    [super nextFrame:dt];
    [self updateTile];
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
    
    CCSprite *spriteA = [CCSprite spriteWithFile:background_file];
    CCSprite *spriteB = [CCSprite spriteWithFile:background_file];
    CCSprite *spriteC = [CCSprite spriteWithFile:background_file];
    CCSprite *spriteD = [CCSprite spriteWithFile:background_file];
    
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
