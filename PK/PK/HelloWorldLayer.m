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
    
    // Radius of ufo sprite
    CGFloat r = MAX(ufo.boundingBox.size.width, ufo.boundingBox.size.height)/2;
    
    // UFO's starting and ending coords
    CGFloat y = fmod((CGFloat)arc4random(), height);
    CGFloat x = width + r;
    CGFloat yEnd = fmod((CGFloat)arc4random(), height);
    CGFloat xEnd = -r;
    
    // Randomly choose where the UFO enters from
    int rand = arc4random() % 4;
    
    // Randomly choose the UFO's speed
    Duration d = (arc4random() % 2) + 2;
    
    switch (rand) {
        case 0:
            // Right to left movement
            // Use value above
            break;
        case 1:
            // Left to right movement
            y = fmod((CGFloat)arc4random(), height);
            x = -r;
            yEnd = fmod((CGFloat)arc4random(), height);
            xEnd = width + r;
            break;
        case 2:
            // Top down movement
            y = height + r;
            x = fmod((CGFloat) arc4random(), width);
            yEnd = -r;
            xEnd = fmod((CGFloat) arc4random(), width);
            break;
        case 3:
            // Down up movement
            y = -r;
            x = fmod((CGFloat) arc4random(), width);
            yEnd = height+r;
            xEnd = fmod((CGFloat) arc4random(), width);
            break;
        default:
            printf("WTF?");
            break;
    }
    
    ufo.position = ccp(x, y);
    
    [self addChild:ufo];
    
    CCMoveTo *move = [CCMoveTo actionWithDuration:d position:ccp(xEnd, yEnd)];
    
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
