//
//  HelloWorldLayer.m
//  PK
//
//  Created by Kevin Yue on 7/1/13.
//  Copyright Kevin Yue 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

//Touch Handler
#import "CCTouchDispatcher.h"

//Adding 2 sprites:
CCSprite *ship;

CGFloat height;
CGFloat width;

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        [self setupVariables];
        
        // do the same for our cocos2d guy, reusing the app icon as its image
        ship = [CCSprite spriteWithFile: @"PlayerShip.tif"];
        ship.position = ccp( width/2, height/2 );
        [self addChild:ship];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        // to enable touch detection
        self.isTouchEnabled = YES;
        
        // Spawn UFOs
        [self schedule:@selector(gameLogic:) interval:1.0];
	}
    
	return self;
}

-(void) setupVariables
{
    height = CCDirector.sharedDirector.winSize.height;
    width = CCDirector.sharedDirector.winSize.width;
}


// Causes the seeker to move every tick
- (void) nextFrame:(ccTime)dt {

}

// Runs every second
-(void)gameLogic:(ccTime)dt {
    [self addUFO];
}

-(void) addUFO{
    CCSprite *ufo = [CCSprite spriteWithFile: @"EnemySaucer.tif"];
    
    // add the UFO randomly off the right edge of the screen
    CGFloat y = fmod((CGFloat)arc4random(), height);
    CGFloat x = width + 50;
    
    ufo.position = ccp(x, y);
    
    [self addChild:ufo];
    
    [self setUFOMovement:ufo];
}

-(void) setUFOMovement:(CCSprite*)ufo{
    Duration d = (arc4random() % 2) + 2;
    CGFloat h = fmod((CGFloat)arc4random(), height);
    CCMoveTo *move = [CCMoveTo actionWithDuration:d position:ccp(0, h)];
    
    CCCallBlockN *moveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    
    [ufo runAction:[CCSequence actions:move, moveDone, nil]];
    
}


// Changes type of touch detection
// TODO: Figure out what calls this...
-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// We need to claim on-touch events, even if we do nothing with them
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

// We also need to claim end-of-touch events
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
    
	[ship stopAllActions];
	[ship runAction: [CCMoveTo actionWithDuration:1 position:location]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
