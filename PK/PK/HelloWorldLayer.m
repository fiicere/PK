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
#import "WallOfDeath.h"
#import "WoDGradient.h"
#import "Bomb.h"

// Data Structures
#import "ScoreKeeper.h"
#import "RandomTrajectory.h"
#import "WorldBoundaries.h"
#import "Settings.h"
#import "Clock.h"
#import "Touch.h"


#import "GameScene.h"
#import "ScoreScene.h"

// Adding 2 sprites:
PlayerShip *ship;

// Screen size
CGFloat screenHeight;
CGFloat screenWidth;

// Projectile stats
const double PROJ_SPEED = 750;
const int RECOIL = -100;
const int EXP_RECOIL = -500;
const CGFloat HOLD_DURATION = 0.5;

NSMapTable * touchDict;

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
        
        if (Settings.getInstance.wt == DIRECTIONAL) {
            [self addDeathWall];
        }
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        // to enable touch detection
        [self setIsTouchEnabled:YES];
        
        //[self runAction:[CCFollow actionWithTarget:ship]];
        
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
    [[GameScene getNonColL] setFocus:ship];
    [[GameScene getEXL] setFocus:ship];
    if (Settings.getInstance.wt == DIRECTIONAL) {
        [[GameScene getWoDL] setFocus:ship];
        [[GameScene getGL] setFocus:ship];
    }
    
    
    
}

-(void) setupVariables
{
    screenHeight = CCDirector.sharedDirector.winSize.height;
    screenWidth = CCDirector.sharedDirector.winSize.width;
    [[Clock getInstance] reset];
    touchDict = [NSMapTable new];
}


// Runs every tick
- (void) nextFrame:(ccTime)dt {
    [self checkCollisions];
    [self checkWoDCollisions];
    [self checkGameOver];
    [self addEnemies:dt];
}


// !!!!!!!!!!!!!!!! COLLISION CHECKING CODE HERE !!!!!!!!!!!!!!!!!!!!
- (void) checkCollisions{
    for (PhysicsSprite *pro in [GameScene getPL].children) {
        CGRect proBox = [pro getBoundingBox];
        // Projectile and Enemy collisions
        for (PhysicsSprite *ufo in [GameScene getEL].children) {
            CGRect ufoBox = [ufo getBoundingBox];
            if (CGRectIntersectsRect(proBox, ufoBox)) {
                ufo.health -= pro.damage;
                pro.health -= ufo.damage;
            }
        }
    }
    for (PhysicsSprite *enemy in [GameScene getEL].children) {
        // Enemy and ship collisions
        if (CGRectIntersectsRect([ship getBoundingBox], [enemy getBoundingBox])) {
            [ship hitWithDamage:enemy.damage];
            enemy.health -= ship.damage;
        }

    }
    // Enemy Projectile and ship collisions
    for (PhysicsSprite *enemyProj in [GameScene getEPL].children) {
        if (CGRectIntersectsRect([ship getBoundingBox], [enemyProj getBoundingBox])) {
            [ship hitWithDamage:enemyProj.damage];
            enemyProj.health -= ship.damage;
        }
    }
    
    // Explosions and Enemies
    for (PhysicsSprite *exp in [GameScene getEXL].children) {
        for (PhysicsSprite *enemy in [GameScene getEL].children) {
            if (CGRectIntersectsRect([exp getBoundingBox], [enemy getBoundingBox])) {
                enemy.health -= exp.damage;
                exp.health -= enemy.damage;
            }
        }
    }

    // Explosions and Ship
    for (PhysicsSprite *exp in [GameScene getEXL].children) {
        if (CGRectIntersectsRect([exp getBoundingBox], [ship getBoundingBox])){
            CGPoint offset = ccpSub(exp.position, ship.position);
            CGFloat norm = sqrt(offset.x*offset.x + offset.y*offset.y);
            CGFloat normX = offset.x / norm;
            CGFloat normY = offset.y / norm;
            [ship pushWithXForce:normX*EXP_RECOIL YForce:normY*EXP_RECOIL];
            [[GameScene getEXL] removeChild:exp cleanup:NO];
            [[GameScene getPL] addChild:exp];

        }
    }
}

-(void)checkWoDCollisions{
    if (Settings.getInstance.wt == DIRECTIONAL) {
        // Ship and WoD
        if (CGRectIntersectsRect([[WallOfDeath getInstance] getBoundingBox], [ship getBoundingBox])){
            [ship die];
        }
        // Ship Projectiles and WoD
        for (PhysicsSprite *pro in [GameScene getPL].children) {
            if (CGRectIntersectsRect([[WallOfDeath getInstance] getBoundingBox], [pro getBoundingBox])){
                [pro die];
            }
        }
        // Enemy Projectile and WoD
        for (PhysicsSprite *enemyProj in [GameScene getEPL].children) {
            if (CGRectIntersectsRect([[WallOfDeath getInstance] getBoundingBox], [enemyProj getBoundingBox])){
                [enemyProj die];
            }
        }
        // Enemy Ships and WoD
        for (PhysicsSprite *enemy in [GameScene getEL].children) {
            if (CGRectIntersectsRect([[WallOfDeath getInstance] getBoundingBox], [enemy getBoundingBox])){
                [enemy die];
            }
        }
    }
}

-(void)spawnEnemiesOfType:(Class)class AtTime:(ccTime)dt{
    [class spawnEnemies:dt];
}

-(void)addEnemies:(ccTime)dt{
    [self spawnEnemiesOfType:[BasicEnemy class] AtTime:dt];
    [self spawnEnemiesOfType:[HomingEnemy class] AtTime:dt];
    [self spawnEnemiesOfType:[Turret class] AtTime:dt];
}

-(void) addDeathWall{
    //WallOfDeath *dw = [[WallOfDeath alloc]init];
//    [WallOfDeath getInstance].position = ccp(-1800, ship.position.y);
    [[WallOfDeath getInstance] reset];
    [[WallOfDeath getInstance] pushWithXForce:100 YForce:0];

    
    if ([GameScene getWoDL].children.count == 0) {

        
        [[GameScene getWoDL] addChild:[WallOfDeath getInstance]];
    }

//    [[GameScene getWoDL] addChild:[WallOfDeath getInstance]];
    
    WoDGradient* grad = [[[WoDGradient alloc]init]autorelease];
    
    [[GameScene getGL] addChild:grad];
}

// Changes type of touch detection
// TODO: Figure out what calls this...
-(void) registerWithTouchDispatcher
{
//	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch * touch in touches){
        CGPoint loc = [self convertTouchToNodeSpace:touch];
        CGFloat time = touch.timestamp;
        CGFloat nt = touch.tapCount;
        Touch * t = [[Touch alloc] initWithLoc:loc Time:time NumTaps:nt];
        [touchDict setObject:t forKey:touch];
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch * touch in touches){
        CGPoint loc = [self convertTouchToNodeSpace: touch];
        Touch * t = [touchDict objectForKey:touch];
        CGFloat touchDuration = touch.timestamp - t.time;
        if(touchDuration < HOLD_DURATION){
            [self addProjectile:loc];
        }
        else{
            [self addBomb:loc];
        }
    }
}

// Add ShipShot
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

// Add Bomb
- (void) addBomb:(CGPoint)loc{
    CGPoint dest = [[GameScene getNonColL] convertToNodeSpace:loc];

    // Add bullet
    Bomb *projectile = [[Bomb alloc] initWithDest:dest];
    projectile.position = ship.position;
    [[GameScene getNonColL] addChild:projectile];
    
    // Find the offset between the touch event and the projectile
    CGPoint offset = ccpSub(loc, projectile.position);
    CGFloat norm = sqrt(offset.x*offset.x + offset.y*offset.y);
    CGFloat normX = offset.x / norm;
    CGFloat normY = offset.y / norm;
    
    // Set the projectile coord to absolute reference frame
    projectile.position = ccp(screenWidth/2 - [GameScene getNonColL].position.x, screenHeight/2 - [GameScene getNonColL].position.y);
    
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
        CCScene *gameOverScene = [[ScoreScene alloc] init];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
    else if([GameScene getSL].children.count <= 0){
        CCScene *gameOverScene = [[ScoreScene alloc] init];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
}

@end
