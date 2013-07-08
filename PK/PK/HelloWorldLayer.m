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
#import "EnemiesLayer.h"
#import "PhysicsSprite.h"
#import "FocusedLayer.h"

// Adding 2 sprites:
PhysicsSprite *ship;

// Screen size
CGFloat height;
CGFloat width;
int score;

// Ship stats
const double SPEED = 750;
const double LIFESPAN = 3;

// Bullet stats
const CGFloat BULLETFORCE = 1.5;

// Agent Arrays
NSMutableArray * _projectiles;

// Layers
HelloWorldLayer *sl;
FocusedLayer *el;

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
    sl = [HelloWorldLayer node];
    
    // Add enemies layer
    el = [FocusedLayer node];
    
	// add layer as a child to scene
	[scene addChild: sl];
    [scene addChild: el];
    
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
        ship = [PhysicsSprite spriteWithFile: @"PlayerShip.tif"];
        [ship setScale:.4];
        [ship fixPosition];
        [el setFocus:ship];
        ship.position = ccp( width/2, height/2 );
        
        [self addChild:ship];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        // to enable touch detection
        self.isTouchEnabled = YES;
        
        // Spawn UFOs timer
        [self schedule:@selector(gameLogic:) interval:1.0];
        
        // Configure agent arrays
        _projectiles = [[NSMutableArray alloc] init];
	}
    
	return self;
}

-(void) setupVariables
{
    height = CCDirector.sharedDirector.winSize.height;
    width = CCDirector.sharedDirector.winSize.width;
    score = 0;
}


// Runs every tick
- (void) nextFrame:(ccTime)dt {
    [self checkCollisions];
<<<<<<< HEAD
<<<<<<< HEAD
=======
    [el setPosition:ccp(el.position.x + el->xVel, el.position.y + el->yVel)];
>>>>>>> parent of 5941e3d... Created New Classes, Fixed Correctness Issue
=======
    [el setPosition:ccp(el.position.x + el->xVel, el.position.y + el->yVel)];
>>>>>>> parent of 5941e3d... Created New Classes, Fixed Correctness Issue
}

- (void) checkCollisions{
//    printf("\n # projectiles = %d", _projectiles.count);

    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *pro in _projectiles) {
        
        NSMutableArray *ufosToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *ufo in el.children) {
            CGRect ufoBox = CGRectOffset(ufo.boundingBox, el.position.x, el.position.y);
            if (CGRectIntersectsRect(pro.boundingBox, ufoBox)) {
                score += 1;
                [ufosToDelete addObject:ufo];
                [projectilesToDelete addObject:pro];
            }
        }
        
        for (CCSprite *ufo in ufosToDelete) {
            [el removeChild:ufo cleanup:YES];
        }
        [ufosToDelete release];
    }
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
    
    for (CCSprite *ufo in el.children) {
        CGRect ufoBox = CGRectOffset(ufo.boundingBox, el.position.x, el.position.y);
        if (CGRectIntersectsRect(ship.boundingBox, ufoBox)) {
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
    
    ufo.position = ccp(x - el.position.x, y - el.position.y);
    [el addChild:ufo];
    
    
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
    CGPoint loc = [self convertTouchToNodeSpace: touch];
    [self addProjectile:loc];    
}

- (void) addProjectile:(CGPoint)loc{
    // Add bullet
    CCSprite *projectile = [CCSprite spriteWithFile:@"PlasmaBall.tif"];
    projectile.position = ship.position;
    [self addChild:projectile];
    
    // Find the offset between the touch event and the projectile
    CGPoint offset = ccpSub(loc, projectile.position);
    CGFloat norm = sqrt(offset.x*offset.x + offset.y*offset.y);
    CGFloat dx = offset.x * SPEED * LIFESPAN / norm;
    CGFloat dy = offset.y * SPEED * LIFESPAN / norm;
    
    // Recoil
    [ship setVelocitydX:(BULLETFORCE * offset.x/norm) dY:(BULLETFORCE * offset.y/norm)];
    
    // Projectile Actions
    CCMoveBy *move = [CCMoveTo actionWithDuration:LIFESPAN position:ccp(projectile.position.x + dx, projectile.position.y + dy)];
    CCCallBlock *moveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [_projectiles removeObject:node];
    }];
    [projectile runAction:[CCSequence actions:move, moveDone, nil]];
    
    // manage ufo list
    projectile.tag = 1;
    [_projectiles addObject:projectile];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	

    
    // release agent arrays
    [_projectiles release];
    _projectiles = nil;
    
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
