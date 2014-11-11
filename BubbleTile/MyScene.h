//
//  MyScene.h
//  BubbleTile
//
//#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
//  Copyright (c) 2014 Isaac. All rights reserved.
//


@interface MyScene : SKScene
    
extern int totalScore;
extern float slowMo;
extern BOOL bubbleOn;
extern BOOL gameOver;

@property(nonatomic) SKAction* repeatSequence;
@property(nonatomic) SKAction* delayz;
-(void) countDown;
-(void) spawnNew;
@end
