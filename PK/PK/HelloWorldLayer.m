//
//  HelloWorldLayer.m
//  PK
//
//  Created by Kevin Yue on 7/1/13.
//  Copyright Kevin Yue 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Import layers
#import "GameOverLayer.h"
#import "FocusedLayer.h"
#import "BackgroundLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

// Touch Handler
#import "CCTouchDispatcher.h"

#import "PhysicsSprite.h"
#import "HomingEnemy.h"

// Data Structures
#import "ScoreKeeper.h"
#import "RandomTrajectory.h"

// Adding 2 sprites:
PhysicsSprite *ship;

// Screen size
CGFloat screenHeight;
CGFloat screenWidth;

// Projectile stats
const double PROJ_SPEED = 750;
const int RECOIL = -100;

// UFO stats
const int UFOVELMIN = 100;
const int UFOVELMAX = 300;
const int UFOSPERTICK = 3;

// Layers
HelloWorldLayer *sl;

FocusedLayer *el;
FocusedLayer *pl;
FocusedLayer *bl;

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer


// Helper class method that creates a Scene
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    // Add enemies layer
    el = [FocusedLayer node];
    
    // Add Projectiles layer
    pl = [FocusedLayer node];
    
    // Add background layer
    bl = [BackgroundLayer node];
    
	// 'layer' is an autorelease object.
    sl = [HelloWorldLayer node];
    
	// add layer as a child to scene
	[scene addChild: sl];
    [scene addChild: el];
    [scene addChild: pl];
    [scene addChild: bl];
    [scene reorderChild:bl z:-1];
    
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

        [self addShip];
        [self setFocus];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        // schedule a timer to run every second
        [self schedule:@selector(gameLogic:) interval:1];
        
        // to enable touch detection
        self.isTouchEnabled = YES;
        
	}
    
	return self;
}

// Creates the main ship
-(void)addShip{
    ship = [[PhysicsSprite alloc] createWithFile: @"Player.tif"];
    ship.position = ccp( screenWidth/2, screenHeight/2 );
    ship.hasFrict = true;
    ship.fixedPosition = true;
    [self addChild:ship];
}

// Sets the focus of all layers to the ship
-(void)setFocus{
    [el setFocus:ship];
    [pl setFocus:ship];
    [bl setFocus:ship];
}

-(void) setupVariables
{
    screenHeight = CCDirector.sharedDirector.winSize.height;
    screenWidth = CCDirector.sharedDirector.winSize.width;
}


// Runs every tick
- (void) nextFrame:(ccTime)dt {
    [self checkCollisions];
}

- (void) checkCollisions{
    for (PhysicsSprite *pro in pl.children) {
        CGRect proBox = [pro getBoundingBox];
        for (PhysicsSprite *ufo in el.children) {
            CGRect ufoBox = [ufo getBoundingBox];
            if (CGRectIntersectsRect(proBox, ufoBox)) {
                ufo.health -= pro.damage;
                pro.health -= ufo.damage;
            }
        }
    }
    
    for (PhysicsSprite *ufo in el.children) {
        if (CGRectIntersectsRect([ship getBoundingBox], [ufo getBoundingBox])) {
            CCScene *gameOverScene = [GameOverLayer sceneWithScore];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
    }
}

// Runs every second
-(void)gameLogic:(ccTime)dt {
    for (int i=0; i<UFOSPERTICK; i++) {
        [self addBasicEnemy];
    }
    [self addHomingEnemy];
}

-(void) addBasicEnemy{
    PhysicsSprite *ufo = [[PhysicsSprite alloc] createWithFile: @"EnemyA.tif"];
    
    ufo.score = 1;
    
    RandomTrajectory *t = [[RandomTrajectory alloc] init];
    
    // Randomly choose the UFO's speed
    CGFloat vel = (arc4random() % (UFOVELMAX-UFOVELMIN)) + UFOVELMIN;
    ufo.position = ccp(t.startX - el.position.x, t.startY - el.position.y);
//    printf("\nstartX = %f", t.startX);
//    printf("\nstartY = %f", t.startY);

    [ufo pushWithXForce:t.trajdX*vel/t.norm YForce:t.trajdY*vel/t.norm];
    [el addChild:ufo];
    
    [t dealloc];
    
//    printf("\nxVel = %f", ufo.xVel);
//    printf(", yVel = %f", ufo.yVel);
}

-(void) addHomingEnemy{
    HomingEnemy *he = [[HomingEnemy alloc] init];
    
    RandomTrajectory *t = [[RandomTrajectory alloc] init];
    
    he.position = ccp(t.startX - el.position.x, t.startY - el.position.y);
    
    [he pushWithXForce:t.trajdX*he.getSpeed/t.norm YForce:t.trajdY*he.getSpeed/t.norm];
    [el addChild:he];
    [t dealloc];

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
    CGPoint loc = [self convertTouchToNodeSpace: touch];
    [self addProjectile:loc];
}

- (void) addProjectile:(CGPoint)loc{
    // Add bullet
    PhysicsSprite *projectile = [[PhysicsSprite alloc] createWithFile:@"Shot.tif"];
    projectile.position = ship.position;
    [pl addChild:projectile];
    
    // Find the offset between the touch event and the projectile
    CGPoint offset = ccpSub(loc, projectile.position);
    CGFloat norm = sqrt(offset.x*offset.x + offset.y*offset.y);
    CGFloat normX = offset.x / norm;
    CGFloat normY = offset.y / norm;
    
    // Set the projectile coord to absolute reference frame
    projectile.position = ccp(screenWidth/2 - pl.position.x, screenHeight/2 - pl.position.y);
    
    // Set projectile speed
    [projectile pushWithXForce:normX*PROJ_SPEED YForce:normY*PROJ_SPEED];
    
    // Recoil
    [ship pushWithXForce:normX*RECOIL YForce:normY*RECOIL];
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)

	// Always call superalloc
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
