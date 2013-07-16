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
#import "BasicEnemy.h"
#import "ShipShot.h"
#import "Turret.h"
#import "PlayerShip.h"

// Data Structures
#import "ScoreKeeper.h"
#import "RandomTrajectory.h"

// Adding 2 sprites:
PlayerShip *ship;

// Screen size
CGFloat screenHeight;
CGFloat screenWidth;

// Projectile stats
const double PROJ_SPEED = 750;
const int RECOIL = -100;

// UFO stats
const int UFOVELMIN = 100;
const int UFOVELMAX = 300;
const int UFOSPERTICK = 1;

// Layers
static HelloWorldLayer *sl;
static FocusedLayer *el;
static FocusedLayer *pl;
static FocusedLayer *bl;
static FocusedLayer *epl;

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
    
    epl = [FocusedLayer node];
    
    // Add Projectiles layer
    pl = [FocusedLayer node];
    
    // Add background layer
    bl = [BackgroundLayer node];
    
	// 'layer' is an autorelease object.
    sl = [HelloWorldLayer node];
    
	// add layer as a child to scene
	[scene addChild: sl];
    [scene addChild: el];
    [scene addChild: epl];
    [scene addChild: pl];
    [scene addChild: bl z:-1];
    
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
        [[ScoreKeeper getInstance] reset];
        
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
    ship = [[PlayerShip alloc] init];
    ship.position = ccp( screenWidth/2, screenHeight/2 );
    ship.hasFrict = true;
    ship.fixedPosition = true;
    [self addChild:ship];
}

// Sets the focus of all layers to the ship
-(void)setFocus{
    [el setFocus:ship];
    [epl setFocus:ship];
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
    [self checkGameOver];
    
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
    
    for (PhysicsSprite *enemy in el.children) {
        if (CGRectIntersectsRect([ship getBoundingBox], [enemy getBoundingBox])) {
            ship.health -= enemy.damage;
            enemy.health -= ship.damage;
        }
    }
    
    for (PhysicsSprite *enemy in epl.children) {
        if (CGRectIntersectsRect([ship getBoundingBox], [enemy getBoundingBox])) {
            ship.health -= enemy.damage;
            enemy.health -= ship.damage;
        }
    }
}

// Runs every second
-(void)gameLogic:(ccTime)dt {
    [self addBasicEnemy];
    [self addHomingEnemy];
    [self addTurret];
}

-(void) addBasicEnemy{
    BasicEnemy *ufo = [[BasicEnemy alloc] init];
    
    RandomTrajectory *t = [[RandomTrajectory alloc] init];
    
    // Randomly choose the UFO's speed
    CGFloat vel = (arc4random() % (UFOVELMAX-UFOVELMIN)) + UFOVELMIN;
    ufo.position = ccp(t.startX - el.position.x, t.startY - el.position.y);

    [ufo pushWithXForce:t.trajdX*vel/t.norm YForce:t.trajdY*vel/t.norm];
    [el addChild:ufo];
    
    [t dealloc];
}

-(void) addHomingEnemy{
    HomingEnemy *he = [[HomingEnemy alloc] init];
    
    RandomTrajectory *t = [[RandomTrajectory alloc] init];
    
    he.position = ccp(t.startX - el.position.x, t.startY - el.position.y);
    
    [he pushWithXForce:t.trajdX*he.getSpeed/t.norm YForce:t.trajdY*he.getSpeed/t.norm];
    [el addChild:he];
    [t dealloc];
}

-(void)addTurret{
    Turret *tur = [[Turret alloc] init];
    
    RandomTrajectory *t = [[RandomTrajectory alloc] init];
    
    tur.position = ccp(t.startX - el.position.x, t.startY - el.position.y);
    
    [tur pushWithXForce:t.trajdX*tur.getSpeed/t.norm YForce:t.trajdY*tur.getSpeed/t.norm];
    [el addChild:tur];
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
    ShipShot *projectile = [[ShipShot alloc] init];
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

-(void) checkGameOver{
    if(ship.health <= 0){
        CCScene *gameOverScene = [GameOverLayer sceneWithScore];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
}

+(FocusedLayer*) getEPL{
    return epl;
}

@end
