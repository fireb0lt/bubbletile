//
//  MyScene.m
//  BubbleTile
//
//  Created by Isaac on 6/7/14.
//  Copyright (c) 2014 Isaac. All rights reserved.
//

#import "MyScene.h"

#import "ViewController.h"
#import "GameOverScene.h"

@implementation MyScene

//-------------------------------------------VARIABLES-------------------------------------------
//Integers
int x;
int y;
int syncHighLabel;
NSInteger theHighScore;
int addedScore=0;
int totalScore = 0;
float slowMo;
float initSloMo = 1.25f;
int gravity=17;
BOOL gameOver;
//SpriteNodes
SKSpriteNode *ball;
SKSpriteNode *touchedNode;
SKEmitterNode *explosion;
SKSpriteNode *overlayFx;
SKSpriteNode *explodingNode;
SKSpriteNode *aboveNode;
SKSpriteNode *rightNode;
SKSpriteNode *belowNode;
SKSpriteNode *leftNode;
SKLabelNode *scoreLabel;
SKLabelNode *highScoreLabel;
SKLabelNode *addLabel;
NSTimer *tripTimer;
//Arrays
NSMutableArray * mySprites;

//Actions
SKAction *playSFX;
SKAction *playSFX2;
SKAction *pulse;
SKAction *delayAction;
SKAction *checkFreq;
SKAction *upwardForce;
SKAction *forceTime;
CGPoint ballcoordinates;
SKAction *rise;
//Floats
float scaleball = 1;
NSTimeInterval delay = 1;

//Booleans
bool leftDel;
bool rightDel;
bool upDel;
bool downDel;
BOOL bubbleOn;


NSUserDefaults *defaults;





//-------------------------------------------METHODS/FUNCTIONS---------------------------------------
__weak MyScene *weakSelf;
-(void)didMoveToView:(SKView *)view{

    
    
}
- (void) retrievePlayerScore {
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    leaderboardRequest.identifier = @"highScore01";
    [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else if (scores) {
            GKScore *localPlayerScore = leaderboardRequest.localPlayerScore;
            int64_t syncedHighScore =localPlayerScore.value;
            NSLog(@"syncedHighScore 0 %i",(int)syncedHighScore);
             //Local High Score
         [defaults setInteger:(int)syncedHighScore forKey:@"SyncGameScore"];
            
           [defaults synchronize];
            
            //highScoreLabel.text = [NSString stringWithFormat:@"High Score: %i",(int)[defaults integerForKey:@"SyncGameScore"]];
           NSLog(@"syncedHighScore AFTER SYNC %i",(int)[defaults integerForKey:@"SyncGameScore"]);
        }
        
    }];
    
}
-(void) addBoundary: (CGSize)size {
    SKNode *bottomEdge = [SKNode node];
    bottomEdge.physicsBody=[SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(size.width, 0)];
    [self addChild:bottomEdge];


    SKNode *leftEdge = [SKNode node];
    leftEdge.physicsBody=[SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(0,size.height)];
    [self addChild:leftEdge];
    
    SKNode *rightEdge = [SKNode node];
    rightEdge.physicsBody=[SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(size.width, 0) toPoint:CGPointMake(size.width, size.height)];
    [self addChild:rightEdge];
    
    SKNode *divideEdge = [SKNode node];
    divideEdge.physicsBody=[SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(64, 0) toPoint:CGPointMake(64, 650)];
    [self addChild:divideEdge];

    SKNode *divide1Edge = [SKNode node];
    divide1Edge.physicsBody=[SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(128, 0) toPoint:CGPointMake(128, 650)];
    [self addChild:divide1Edge];

    SKNode *divide2Edge = [SKNode node];
    divide2Edge.physicsBody=[SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(192, 0) toPoint:CGPointMake(192, 650)];
    [self addChild:divide2Edge];

    SKNode *divide3Edge = [SKNode node];
    divide3Edge.physicsBody=[SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(256, 0) toPoint:CGPointMake(256, 650)];
    [self addChild:divide3Edge];
}
//Pick Bubble Color
-(NSString*) pickColor{
    int randomBubbleInteger = (arc4random() %3);
    
    switch (randomBubbleInteger) {
        case 0:
            return @"lime";
            break;
        case 1:
        {
            return @"blu";
            break;
        }
        case 2:
        {
            return @"pink";
            break;
        }
        case 3:
        {
            return @"red";
            break;
        }
            
        default:
            break;
    }
    
    return nil;
}
//Spawn new Bubble

-(void) spawnNew{
  if (bubbleOn==YES) {
        int pickColInteger = (arc4random() %5);
        CGPoint spawnPoint = CGPointMake(34.0+(64*pickColInteger), self.size.height-33);
        
        NSString *ballName = [self pickColor];
        ball = [SKSpriteNode spriteNodeWithImageNamed:ballName];
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width/2];
        ball.position = spawnPoint;
        ball.scale = scaleball;
        ball.name = ballName;
        ball.physicsBody.mass=.2f;
        ball.alpha = 0.9;
        [weakSelf addChild:ball];
    

    NSLog(@"%f",slowMo);
        
        tripTimer=[NSTimer scheduledTimerWithTimeInterval:slowMo target:weakSelf selector:@selector(spawnNew) userInfo:nil repeats:NO];
        return;
  } else {
        return;
  }


}




-(void) countDown {
    SKLabelNode *pauseLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    pauseLabel.text = @"Play in";
    pauseLabel.fontSize=45;
    pauseLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [overlayFx addChild:pauseLabel];
    
}
-(void) endGameCheck{
    for (int z=0; z<5; z++) {
        CGPoint checkPoint = CGPointMake(34.0+(64*z), self.size.height+32);
        SKSpriteNode *checkNode =(SKSpriteNode *)[self nodeAtPoint:checkPoint];
        
       
        if (checkNode.name == nil || checkNode==overlayFx) {
           
        } else{
            
            bubbleOn=NO;
            gameOver=YES;
            NSLog(@"GAME OVER:%i",gameOver);
            

            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadEnd" object:nil];
           
        }
        
        
    }
}

-(void)updateSlo{
    if (slowMo>0.23) {
        slowMo = slowMo-0.0045;
    } else {
        return;
    }
    
}
-(void)stopTimer
{
    [tripTimer invalidate];
}

-(void)startTimer{
    tripTimer=[NSTimer scheduledTimerWithTimeInterval:slowMo target:weakSelf selector:@selector(spawnNew) userInfo:nil repeats:NO];

}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"startBubbles"]) {
        [self startTimer];
    } else if ([notification.name isEqualToString:@"stopBubbles"]) {
        [self stopTimer];
    }
}
//Initializer Method
-(instancetype)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
         defaults = [NSUserDefaults standardUserDefaults];
        
        
        gameOver=NO;
        //Setup initial conditions
        slowMo=initSloMo;
         bubbleOn=YES;
        mySprites = [NSMutableArray array];
        [self addBoundary:size];
        //World
        self.physicsWorld.gravity = CGVectorMake(0,-gravity);
        self.physicsBody.friction = 0;
        self.physicsBody.linearDamping = 0;
        self.physicsBody.restitution = 0;
        
        overlayFx=[SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        overlayFx.userInteractionEnabled=NO;
        
        overlayFx.zPosition=-1;
        [self addChild:overlayFx];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"startBubbles" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"stopBubbles" object:nil];


       //Score Setup
       
           [defaults synchronize];
        
        theHighScore = [defaults integerForKey:@"HighScore"]; //Local High Score
       
        
        
        

        
        
        NSLog(@"Local: %li",(long)theHighScore);

        NSLog(@"%i",_enableGameCenter);
        
        
        
        
        
        
        
        
        
        
        
        
        weakSelf = self;
          SKAction *updateSlowMo = [SKAction runBlock:^{
            [weakSelf updateSlo];
            
        }];
        SKAction *wait = [SKAction waitForDuration:1.0];
               SKAction *spawnSequence =[SKAction sequence:@[updateSlowMo,wait]];
                [self runAction:[SKAction repeatActionForever:spawnSequence]];
   
        //add score label text
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        scoreLabel.fontColor = [SKColor blackColor];
        scoreLabel.fontSize = 24;
        scoreLabel.text = @"Score: 0";
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        scoreLabel.position=CGPointMake(self.size.width/2,self.size.height-24);
        [overlayFx addChild:scoreLabel];
        
        highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        highScoreLabel.fontColor = [SKColor blackColor];
        highScoreLabel.fontSize = 16;
        
        [self retrievePlayerScore];
        /*
        if (patchedAuthenticate==YES ) {
            
            [self retrievePlayerScore];
        } else {
           highScoreLabel.text = [NSString stringWithFormat:@"High Score: %li",(long)theHighScore];
        }
       
        */
        
        highScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        highScoreLabel.position=CGPointMake(self.size.width/2,self.size.height-48);
        [overlayFx addChild:highScoreLabel];
        
        
        //add + Label
        addLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        addLabel.fontColor = [SKColor blackColor];
        addLabel.fontSize = 48;
        addLabel.text = @"";
        addLabel.alpha = 0.2;
        addLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        addLabel.position=CGPointMake(self.size.width/2,self.size.height-65);
        [overlayFx addChild:addLabel];
   
 
        
        //Setup SKActions
        SKAction *fadeOut = [SKAction fadeOutWithDuration: .7];
        SKAction *fadeIn = [SKAction fadeInWithDuration: .25];
        rise = [SKAction moveBy:CGVectorMake(0, 100) duration:.5];
        pulse = [SKAction sequence:@[fadeIn,fadeOut]];
        
  // tripTimer=[NSTimer scheduledTimerWithTimeInterval:slowMo target:weakSelf selector:@selector(spawnNew) userInfo:nil repeats:NO];
        [self startTimer];
        
        
        //Check if game ends
        SKAction *delay = [SKAction waitForDuration:.05f];
        SKAction *check= [SKAction performSelector:@selector(endGameCheck) onTarget:self];
        SKAction *checkSequence = [SKAction sequence:@[delay, check]];
        SKAction *repeatCheck   = [SKAction repeatActionForever:checkSequence];
        [self runAction:repeatCheck];
        
        
        //Add pop
        playSFX = [SKAction playSoundFileNamed:@"pop6.wav" waitForCompletion:NO];
        playSFX2 = [SKAction playSoundFileNamed:@"pop6.wav" waitForCompletion:NO];
                //Add bubbles to scene
        
    }
    
    self.backgroundColor = [SKColor whiteColor];
    
    
    

    

    return self;
    
}




//Add Bubble pop explosion emitters
-(void) addExplosion: (CGPoint) checkz selectColor: (NSString*)colorName{
    CGPoint checkOffset = CGPointMake(checkz.x, checkz.y);
    
    if ([colorName isEqual:@"lime"]) {
        explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"Explosion" ofType:@"sks"]];
        explosion.position=checkOffset;
        explosion.userInteractionEnabled=NO;
        
        [overlayFx addChild:explosion];
        explosion.numParticlesToEmit = 160;
    }
   if ([colorName isEqual:@"blu"]) {
        explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"BlueExplosion" ofType:@"sks"]];
        explosion.position=checkOffset;
       explosion.userInteractionEnabled=NO;

        [overlayFx addChild:explosion];
        explosion.numParticlesToEmit = 160;
    }
    
    if ([colorName isEqual:@"yellow"]) {
        explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"YellowExplosion" ofType:@"sks"]];
        explosion.position=checkOffset;
       explosion.userInteractionEnabled=NO;

        [overlayFx addChild:explosion];
        explosion.numParticlesToEmit = 100;
    }
    

    if ([colorName isEqual:@"pink"]) {
        explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"RedExplosion" ofType:@"sks"]];
        explosion.position=checkOffset;
       explosion.userInteractionEnabled=NO;
        [overlayFx addChild:explosion];
        explosion.numParticlesToEmit = 160;
    }
    

}

//Floodfill bubble selection & deletion
-(int) deleteBubbles: (CGPoint) check withColorName:(NSString*) color{
    
    SKSpriteNode *selNode =(SKSpriteNode *)[self nodeAtPoint:check];
  
    
    if (![selNode.name isEqualToString:color]) {
        return 0;
    } else {
        selNode.alpha = 0.2;
        selNode.name=@"marked";
        [mySprites addObject:selNode];
        
        [self addExplosion:selNode.position selectColor:color];
        
        [self deleteBubbles:CGPointMake(selNode.position.x + 63, selNode.position.y) withColorName:color];
        [self deleteBubbles:CGPointMake(selNode.position.x, selNode.position.y + 63) withColorName:color];
        [self deleteBubbles:CGPointMake(selNode.position.x - 63, selNode.position.y) withColorName:color];
        [self deleteBubbles:CGPointMake(selNode.position.x, selNode.position.y - 63) withColorName:color];

        addedScore++;
        return addedScore;
    }
}

//Check 4 surround bubbles for equal color
-(BOOL) checkSurround: (CGPoint) check withColorName:(NSString*) color{
    SKSpriteNode *checkNode = (SKSpriteNode *)[self nodeAtPoint:check];
  
    CGPoint above= CGPointMake(checkNode.position.x, checkNode.position.y + 63);
    CGPoint right= CGPointMake(checkNode.position.x + 63, checkNode.position.y);
    CGPoint below= CGPointMake(checkNode.position.x, checkNode.position.y - 63);
    CGPoint left= CGPointMake(checkNode.position.x - 63, checkNode.position.y);
    
    aboveNode =(SKSpriteNode *)[self nodeAtPoint:above];

    rightNode =(SKSpriteNode *)[self nodeAtPoint:right];

    belowNode =(SKSpriteNode *)[self nodeAtPoint:below];

    leftNode =(SKSpriteNode *)[self nodeAtPoint:left];

    
    if   ([aboveNode.name isEqual:color] || [rightNode.name isEqual:color] || [belowNode.name isEqual:color] || [leftNode.name isEqual:color]) {
        return YES;
    } else {
        return NO;
    }
}

//Score modify to weight score
int modifiedAddedScore(int x){
    int g=0;
    if (x <=2) {
        return g=x;
    }
    else if (x<=5){
        return g=2*x;
        //X2!
    }
    else if (x<=10){
        //X3!
        return g=4*x;
    }
    else if (x<=15){
        //X4!
        return g=5*x;
    }
    else if (x<=20){
        //X5! Wow!
        return g=10*x;
    }
    else if (x<=30){
        //Insane!
        return g = x*20;
    }
    else if (x<=50){
        //Insane!
        return g = x*30;
    }
    return 0;
}


//---------------------------------------MAIN-------------------------------------------------------
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    
    UITouch *touch = [touches anyObject];
    touchedNode = (SKSpriteNode *)[self nodeAtPoint:[touch locationInNode:self]];
    BOOL twoPlus = [self checkSurround:touchedNode.position withColorName:touchedNode.name];
    if (touchedNode==overlayFx) {
        NSLog(@"overlay");
    }
    if (twoPlus == YES && touchedNode != overlayFx) {
        mySprites=[[NSMutableArray alloc] initWithObjects: nil];
        addedScore=0;
        //Call deleteBubbles, pass in touchedNode's position, color
        addedScore = [self deleteBubbles:touchedNode.position withColorName:touchedNode.name];
        //Pop Bubbles, return score
        //add score to total        //update total score in label
       
        int modScore=modifiedAddedScore(addedScore);
        addLabel.position=CGPointMake(touchedNode.position.x, touchedNode.position.y+65);
        addLabel.text = [NSString stringWithFormat:@"+%i",modScore];
        [addLabel runAction:rise];
        [addLabel runAction:pulse];
        totalScore = modScore+totalScore;
        scoreLabel.text = [NSString stringWithFormat:@"SCORE:%i",totalScore];
        [self runAction:playSFX ];
   
        for(id obj in mySprites){
            
            [obj removeFromParent];
            

        }
        [mySprites removeAllObjects];
   
    } else {
        return;
    }
    
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (_enableGameCenter==YES){
        highScoreLabel.text = [NSString stringWithFormat:@"High Score: %i",(int)[defaults integerForKey:@"SyncGameScore"]];
    } else {
        highScoreLabel.text = [NSString stringWithFormat:@"High Score: %li",(long)theHighScore];
    }
}

@end
