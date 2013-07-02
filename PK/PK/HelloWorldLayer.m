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
CCSprite *seeker1;
CCSprite *cocosGuy;

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
        // create and initialize our seeker sprite, and add it to this layer
        seeker1 = [CCSprite spriteWithFile: @"EnemySaucer.tif"];
        seeker1.position = ccp( 50, 100 );
        [self addChild:seeker1];
        
        // do the same for our cocos2d guy, reusing the app icon as its image
        cocosGuy = [CCSprite spriteWithFile: @"PlayerShip.tif"];
        cocosGuy.position = ccp( 200, 300 );
        [self addChild:cocosGuy];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        // to enable touch detection
        self.isTouchEnabled = YES;
	}
    
	return self;
}


// Causes the seeker to move every tick
- (void) nextFrame:(ccTime)dt {
    seeker1.position = ccp( seeker1.position.x + 100*dt, seeker1.position.y );
    if (seeker1.position.x > CCDirector.sharedDirector.winSize.width) {
        seeker1.position = ccp(0 , seeker1.position.y );
    }
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
    
	[cocosGuy stopAllActions];
	[cocosGuy runAction: [CCMoveTo actionWithDuration:1 position:location]];
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
