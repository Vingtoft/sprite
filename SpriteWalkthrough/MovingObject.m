//
//  MovingObject.m
//  SpriteWalkthrough
//
//  Created by Oscar Andersen on 18/02/14.
//  Copyright (c) 2014 Oscar Andersen. All rights reserved.
//

#import "MovingObject.h"
#import "SpaceshipScene.h"

@interface MovingObject ()
@property BOOL contentCreated;
@property int snake_x, snake_y;
@end

@implementation MovingObject
SKSpriteNode *snake, *wall;

- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    //initialize variables
    self.snake_x = CGRectGetMidX(self.frame);
    self.snake_y = CGRectGetMidY(self.frame);
    //initialize graphics
    self.backgroundColor = [SKColor greenColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    //create game nodes
    snake = [self addSnake];
    wall = [self addWall];
    
    //add game nodes
    [self addChild: snake];
    [self addChild: wall];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    SKAction *moveSnake = [SKAction moveByX:0 y:5 duration:0.1];
    [snake runAction:[SKAction repeatAction:moveSnake count:1]];
    
}

/*Node descriptions BEGIN*/

- (SKSpriteNode *)addSnake
{
    SKSpriteNode *snake = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(10,10)];
    snake.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    snake.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:snake.size];
    snake.physicsBody.dynamic = NO;
    snake.physicsBody.usesPreciseCollisionDetection = YES;
    return snake;
}

- (SKSpriteNode *)addWall
{
    SKSpriteNode *wall = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(200, 5)];
    wall.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+50);
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:snake.size];
    wall.physicsBody.dynamic = NO;
    
    return wall;
}

/* Node description END */


@end
