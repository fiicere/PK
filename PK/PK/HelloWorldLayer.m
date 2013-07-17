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


#import "GameScene.h"

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

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

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
    
    [[GameScene getEL] setFocus:ship];
    [[GameScene getEPL] setFocus:ship];
    [[GameScene getPL] setFocus:ship];
    [[GameScene getBL] setFocus:ship];
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
    for (PhysicsSprite *pro in [GameScene getPL].children) {
        CGRect proBox = [pro getBoundingBox];
        for (PhysicsSprite *ufo in [GameScene getEL].children) {
            CGRect ufoBox = [ufo getBoundingBox];
            if (CGRectIntersectsRect(proBox, ufoBox)) {
                ufo.health -= pro.damage;
                pro.health -= ufo.damage;
            }
        }
    }
    
    for (PhysicsSprite *enemy in [GameScene getEL].children) {
        if (CGRectIntersectsRect([ship getBoundingBox], [enemy getBoundingBox])) {
            ship.health -= enemy.damage;
            enemy.health -= ship.damage;
        }
    }
    
    for (PhysicsSprite *enemy in [GameScene getEPL].children) {
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
    ufo.position = ccp(t.startX - [GameScene getEL].position.x, t.startY - [GameScene getEL].position.y);

    [ufo pushWithXForce:t.trajdX*vel/t.norm YForce:t.trajdY*vel/t.norm];
    [[GameScene getEL] addChild:ufo];
    
    [t dealloc];
}

-(void) addHomingEnemy{
    HomingEnemy *he = [[HomingEnemy alloc] init];
    
    RandomTrajectory *t = [[RandomTrajectory alloc] init];
    
    he.position = ccp(t.startX - [GameScene getEL].position.x, t.startY - [GameScene getEL].position.y);
    
    [he pushWithXForce:t.trajdX*he.getSpeed/t.norm YForce:t.trajdY*he.getSpeed/t.norm];
    [[GameScene getEL] addChild:he];
    [t dealloc];
}

-(void)addTurret{
    Turret *tur = [[Turret alloc] init];
    
    RandomTrajectory *t = [[RandomTrajectory alloc] init];
    
    tur.position = ccp(t.startX - [GameScene getEL].position.x, t.startY - [GameScene getEL].position.y);
    
    [tur pushWithXForce:t.trajdX*tur.getSpeed/t.norm YForce:t.trajdY*tur.getSpeed/t.norm];
    [[GameScene getEL] addChild:tur];
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
    [[GameScene getPL] addChild:projectile];
    
    // Find the offset between the touch event and the projectile
    CGPoint offset = ccpSub(loc, projectile.position);
    CGFloat norm = sqrt(offset.x*offset.x + offset.y*offset.y);
    CGFloat normX = offset.x / norm;
    CGFloat normY = offset.y / norm;
    
    // Set the projectile coord to absolute reference frame
    projectile.position = ccp(screenWidth/2 - [GameScene getPL].position.x, screenHeight/2 - [GameScene getPL].position.y);
    
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
    return [GameScene getEPL];
}

@end
