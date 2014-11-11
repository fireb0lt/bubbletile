//
//  GameOverScene.m
//  BubbleTile
//
//  Created by Isaac on 7/21/14.
//  Copyright (c) 2014 Isaac. All rights reserved.
//

#import "GameOverScene.h"
#import "MyScene.h"
int64_t syncedHighScore;
SKSpriteNode *restartButton;
SKSpriteNode *leaderboardButton;
SKSpriteNode *highNotice;
SKLabelNode *scoreLabel;
SKLabelNode *highNode;
SKSpriteNode *touchedNode;

@implementation GameOverScene
int64_t syncedHighScore;
NSUserDefaults *defaults;
SKEmitterNode *greenFire;
//-----------------------GAME CENTER ---------------------------------------------------

-(void)reportScore:(int)submitScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"highScore01"];
    score.value =  submitScore;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}
- (void) retrievePlayerScore {
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    leaderboardRequest.identifier = @"highScore01";
    [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else if (scores) {
            GKScore *localPlayerScore = leaderboardRequest.localPlayerScore;
            syncedHighScore =localPlayerScore.value;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:(int)syncedHighScore forKey:@"SyncGameScore"];
            [defaults synchronize];
            
        }
    }];
    
}

//---------------------------------------------------------------------------------
-(void) loadScoreLabel{
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %i",totalScore];
    scoreLabel.fontSize=30;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+125);
    scoreLabel.fontColor=[UIColor blackColor];
    [self addChild:scoreLabel];
    scoreLabel.scale = 0.02;
    SKAction *expandScore = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *bounce1 = [SKAction scaleTo:0.9 duration:0.1];
    SKAction *bounce2 = [SKAction scaleTo:1 duration:0.1];
    
    
    [scoreLabel runAction:[SKAction sequence:@[expandScore,bounce1,bounce2]]];
}

-(void) loadRestartButton{
    restartButton = [SKSpriteNode spriteNodeWithImageNamed:@"button_07.png"];//-------------------
    restartButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    restartButton.scale = 0.03;
    restartButton.name=@"Restart";
    SKLabelNode *restartLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    
    restartLabel.fontColor=[UIColor whiteColor];
    restartLabel.text = [NSString stringWithFormat:@"Play Again!"];
    restartLabel.fontSize=25;
    restartLabel.position = CGPointMake(0, -8);
    restartLabel.name=@"restartText";
    
    
    [self addChild:restartButton];
    [restartButton addChild:restartLabel];
    SKAction *expandRestart = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *bounce1 = [SKAction scaleTo:0.9 duration:0.1];
    SKAction *bounce2 = [SKAction scaleTo:1 duration:0.1];

    SKAction *loadRBSequence=[SKAction sequence:@[expandRestart,bounce1,bounce2]];
    [restartButton runAction:loadRBSequence];
    
    
 }




-(id)initWithSize:(CGSize)size{
    if (self=[super initWithSize:size]) {
        SKSpriteNode *overlayFx=[SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        overlayFx.userInteractionEnabled=NO;
        
        overlayFx.zPosition=-1;
        [self addChild:overlayFx];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil]; //Sends message to viewcontroller to show ad.
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil]; //Sends message to viewcontroller to
        greenFire = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"GreenFire" ofType:@"sks"]];

        bubbleOn=NO;
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];

        NSInteger highScore = [defaults integerForKey:@"HighScore"];
        
        SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        gameOverLabel.text = @"GAME OVER";
        gameOverLabel.fontSize=30;
        gameOverLabel.fontColor=[UIColor blackColor];
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:gameOverLabel];
        
        
        
        SKAction *loadScore= [SKAction performSelector:@selector(loadScoreLabel) onTarget:self];
        
        
        gameOverLabel.scale = 0.02;
        SKAction *expandGOLabel = [SKAction scaleTo:1.0 duration:0.5];
        SKAction *delayGO = [SKAction waitForDuration:0.5];
        SKAction *fadeGOLabel = [SKAction fadeOutWithDuration:0.25];
        SKAction *hideGOLabel = [SKAction scaleTo:.1 duration:0.15];
        SKAction *goLabelAnimation=[SKAction sequence:@[expandGOLabel,delayGO,hideGOLabel,fadeGOLabel]];
        [gameOverLabel runAction:goLabelAnimation];
        
        
        
        
        SKAction *delayLoadScore = [SKAction waitForDuration:1.5];
      
        
        SKAction *loadScoreSequence=[SKAction sequence:@[delayLoadScore,loadScore]];
        [self runAction:loadScoreSequence];
        
        
        
        SKAction *loadRestart= [SKAction performSelector:@selector(loadRestartButton) onTarget:self];
        SKAction *loadRestartSequence=[SKAction sequence:@[delayLoadScore,loadRestart]];
        [self runAction:loadRestartSequence];

        
        
        
        
        
        SKAction *expandRestart = [SKAction scaleTo:1.0 duration:0.5];
        SKAction *bounce1 = [SKAction scaleTo:0.8 duration:0.1];
        SKAction *bounce2 = [SKAction scaleTo:1 duration:0.1];
        
        SKAction *loadRBSequence=[SKAction sequence:@[delayLoadScore,expandRestart,bounce1,bounce2]];

        highNode = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        highNode.fontColor=[UIColor blackColor];
        highNode.fontSize=24;
        highNode.name = @"leaderboardText";
        highNode.scale = 0.02;
        highNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-150);

        highNotice = [SKSpriteNode spriteNodeWithImageNamed:@"button_03.png"];//----------------------
  
        if (_enableGameCenter==YES) {
          
       
            
            if (totalScore > [defaults integerForKey:@"SyncGameScore"]) {
               
                
                [defaults setInteger:totalScore forKey:@"SyncGameScore"];
                [defaults synchronize];
                
                highNode.text = [NSString stringWithFormat:@"New High Score!"];
                [self addChild:highNode];
                [highNode runAction:loadRBSequence];
                [self reportScore:totalScore];
                
            } else {


                highNode.text = [NSString stringWithFormat:@"High Score: %li",(long)[defaults integerForKey:@"SyncGameScore"]];

                
                [self addChild:highNode];
                
                
                [highNode runAction:loadRBSequence];
            }
            
            
            //OTHERWISE
            
        } else {
            if (totalScore > [defaults integerForKey:@"HighScore"]) {
                [defaults setInteger:totalScore forKey:@"HighScore"];
                [defaults synchronize];
       
                
                [self addChild:highNode];
                highNode.text = [NSString stringWithFormat:@"New High Score!"];
                [highNode runAction:loadRBSequence];
           

            } else {
       
                highNode.text = [NSString stringWithFormat:@"High Score: %li",(long)highScore];
                
                
                [self addChild:highNode];
                
              
              
                [highNode runAction:loadRBSequence];
     
                
            }
            
        }
        
        
        
        

        [self retrievePlayerScore];
    
    }
    
    return self;
}
    
-(void)restartGame{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadStart" object:nil];

}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    touchedNode = (SKSpriteNode *)[self nodeAtPoint:[touch locationInNode:self]];
    if ([touchedNode.name isEqual:@"Restart"]||[touchedNode.name isEqual:@"restartText"]) {
        
        greenFire.position=CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)) ;
        greenFire.numParticlesToEmit=100;
        [self addChild:greenFire];
        SKAction *shrink = [SKAction scaleTo:0.02 duration:0.5];
        SKAction *restart= [SKAction performSelector:@selector(restartGame) onTarget:self];
        SKAction *loadRBSequence=[SKAction sequence:@[shrink,restart]];

        [restartButton runAction:loadRBSequence];


        
    } else {
        return;
    }
        
    
    totalScore=0;
    
    
   
    
    
    
}


    
    
    
    
    
    
    
@end
