//
//  SpaceshipScene.m
//  SpriteWalkthrough
//
//  Created by Oscar Andersen on 17/02/14.
//  Copyright (c) 2014 Oscar Andersen. All rights reserved.
//

#import "SpaceshipScene.h"
#import "MovingObject.h"

@interface SpaceshipScene ()

@property BOOL contentCreated;

@end

@implementation SpaceshipScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
            
            SKScene *spaceshipScene  = [[MovingObject alloc] initWithSize:self.size];
            
            SKTransition *doors = [SKTransition doorsCloseHorizontalWithDuration:0.5];
            
            [self.view presentScene:spaceshipScene transition:doors];
}
    


- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    SKSpriteNode *spaceship = [self newSpaceship];
    SKSpriteNode *spaceship2 = [self newSpaceship];
    
    SKSpriteNode *box = [self addBox];
    
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-150);
    spaceship2.position = CGPointMake(CGRectGetMidX(self.frame)+150, CGRectGetMidY(self.frame)+150);
    
    box.position = CGPointMake(CGRectGetMidX(self.frame)-300, CGRectGetMidY(self.frame)-300);
    
    
    
    [self addChild:spaceship];
    [self addChild:spaceship2];
    
    [self addChild:box];
    
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:.1 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeRocks]];
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (SKSpriteNode *)addBox
{
    SKSpriteNode *box = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size: CGSizeMake(400, 1)];
    box.position = CGPointMake(50, 50);
    box.name = @"box";
    box.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box.size];
    
    box.physicsBody.dynamic = NO;
    
    SKAction *movement = [SKAction sequence:@[[SKAction waitForDuration:2.0],
                                              [SKAction moveByX:20 y:1000 duration:5.0],
                                              [SKAction waitForDuration:0.5],
                                              [SKAction moveByX:-20 y:-1000 duration:2]]];
    [box runAction:[SKAction repeatActionForever:movement]];
    
    return box;
}

- (void)addRock
{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(8,8)];
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rock];
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}

- (SKSpriteNode *)newSpaceship
{
    SKSpriteNode *hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64,32)];
    //hull objektet er nu omfattet af fysiske love (gravity ect)
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    //Slå physics fra
    hull.physicsBody.dynamic = NO;
    //create childnode
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    [hull addChild:light1];
    //create childnode
    SKSpriteNode *light2 = [self newLight];
    light2.position = CGPointMake(28.0, 6.0);
    [hull addChild:light2];
    //create childnode
    SKSpriteNode *light3 = [self newLight];
    light3.position = CGPointMake(0.0, 6.0);
    [hull addChild:light3];
    //set behavior for the sprite
    SKAction *hover = [SKAction sequence:@[[SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:50.0 duration:1.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100.0 y:-50 duration:1.0]]];
    //enable it
    [hull runAction: [SKAction repeatActionForever:hover]];
    
    return hull;
}

- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction: blinkForever];
    
    return light;
}


@end










