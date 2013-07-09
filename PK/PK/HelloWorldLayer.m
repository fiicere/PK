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

// Touch Handler
#import "CCTouchDispatcher.h"

#import "GameOverLayer.h"

#import "FocusedLayer.h"
#import "PhysicsSprite.h"

// Adding 2 sprites:
PhysicsSprite *ship;

// Screen size
CGFloat screenHeight;
CGFloat screenWidth;
int score;

// Projectile stats
const double SPEED = 750;
const int RECOIL = -100;

// UFO speed variations
const int UFOVELMIN = 100;
const int UFOVELMAX = 300;

// Layers
HelloWorldLayer *sl;

FocusedLayer *el;
FocusedLayer *pl;

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
    
	// 'layer' is an autorelease object.
    sl = [HelloWorldLayer node];
    
	// add layer as a child to scene
	[scene addChild: sl];
    [scene addChild: el];
    [scene addChild: pl];
    
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

        ship = [[PhysicsSprite alloc] createWithFile: @"PlayerShip.tif"];
        [ship setScale:.4];
        ship.position = ccp( screenWidth/2, screenHeight/2 );
        [self addChild:ship];
        [el setFocus:ship];
        [pl setFocus:ship];
        ship.hasFrict = true;
        ship.fixedPosition = true;
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        // to enable touch detection
        self.isTouchEnabled = YES;
        
        // Spawn UFOs timer
        [self schedule:@selector(gameLogic:) interval:1.0];
	}
    
	return self;
}

-(void) setupVariables
{
    screenHeight = CCDirector.sharedDirector.winSize.height;
    screenWidth = CCDirector.sharedDirector.winSize.width;
    score = 0;
}


// Runs every tick
- (void) nextFrame:(ccTime)dt {
    [self checkCollisions];
}

- (void) checkCollisions{
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (PhysicsSprite *pro in pl.children) {
        CGRect proBox = [pro getBoundingBox];
        NSMutableArray *ufosToDelete = [[NSMutableArray alloc] init];
        for (PhysicsSprite *ufo in el.children) {
            CGRect ufoBox = [ufo getBoundingBox];
            if (CGRectIntersectsRect(proBox, ufoBox)) {
                score += 1;
                [ufosToDelete addObject:ufo];
                [projectilesToDelete addObject:pro];
            }
        }
        
        for (PhysicsSprite *ufo in ufosToDelete) {
            [el removeChild:ufo cleanup:YES];
        }
        [ufosToDelete release];
    }
    for (PhysicsSprite *projectile in projectilesToDelete) {
        [pl removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
    
    for (PhysicsSprite *ufo in el.children) {
        if (CGRectIntersectsRect([ship getBoundingBox], [ufo getBoundingBox])) {
            CCScene *gameOverScene = [GameOverLayer sceneWithScore:score];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
    }
}

// Runs every second
-(void)gameLogic:(ccTime)dt {
    [self addUFO];
}
-(void) addUFO{
    PhysicsSprite *ufo = [[PhysicsSprite alloc] createWithFile: @"EnemySaucer.tif"];
    
    // Radius of ufo sprite
    CGFloat r = MAX(ufo.boundingBox.size.width, ufo.boundingBox.size.height)/2;
    
    // UFO's starting and ending coords
    CGFloat y = fmod((CGFloat)arc4random(), screenHeight);
    CGFloat x = screenWidth + r;
    CGFloat yEnd = fmod((CGFloat)arc4random(), screenHeight);
    CGFloat xEnd = -r;
    
    // Randomly choose where the UFO enters from
    int rand = arc4random() % 4;
    
    // Randomly choose the UFO's speed
    CGFloat vel = (arc4random() % (UFOVELMAX-UFOVELMIN)) + UFOVELMIN;
    
    switch (rand) {
        case 0:
            // Right to left movement
            // Use value above
            break;
        case 1:
            // Left to right movement
            y = fmod((CGFloat)arc4random(), screenHeight);
            x = -r;
            yEnd = fmod((CGFloat)arc4random(), screenHeight);
            xEnd = screenWidth + r;
            break;
        case 2:
            // Top down movement
            y = screenHeight + r;
            x = fmod((CGFloat) arc4random(), screenWidth);
            yEnd = -r;
            xEnd = fmod((CGFloat) arc4random(), screenWidth);
            break;
        case 3:
            // Down up movement
            y = -r;
            x = fmod((CGFloat) arc4random(), screenWidth);
            yEnd = screenHeight+r;
            xEnd = fmod((CGFloat) arc4random(), screenWidth);
            break;
        default:
            printf("WTF?");
            break;
    }
    
    ufo.position = ccp(x - el.position.x, y - el.position.y);
    
    CGFloat dx = xEnd - x;
    CGFloat dy = yEnd - y;
    CGFloat norm = sqrt(dx*dx + dy*dy);
    [ufo pushWithXForce:dx*vel/norm YForce:dy*vel/norm];
    [el addChild:ufo];
    
//    printf("\nxVel = %f", ufo.xVel);
//    printf(", yVel = %f", ufo.yVel);
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
    PhysicsSprite *projectile = [[PhysicsSprite alloc] createWithFile:@"PlasmaBall.tif"];
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
    [projectile pushWithXForce:normX*SPEED YForce:normY*SPEED];
    
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
