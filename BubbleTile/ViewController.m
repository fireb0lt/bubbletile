//
//  ViewController.m
//  BubbleTile
//
//  Created by Isaac on 6/7/14.
//  Copyright (c) 2014 Isaac. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
- (BOOL) prefersStatusBarHidden{
    return YES;
}
NSUserDefaults *defaults;
SKScene * scene;
NSTimer *myTimer;


-(void)reportScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"highScore01"];
    score.value = 0;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            _enableGameCenter=NO;
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}
- (void) retrievePlayerScore {
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    leaderboardRequest.identifier = @"highScore01";
    [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        if (error) {
            _enableGameCenter=NO;
            NSLog(@"%@", error);
        } else if (scores) {
            GKScore *localPlayerScore = leaderboardRequest.localPlayerScore;
            int64_t syncedHighScore =localPlayerScore.value;
            //NSLog(@"syncedHighScore %i",(int)syncedHighScore);
            //Local High Score
            [defaults setInteger:(int)syncedHighScore forKey:@"SyncGameScore"];
            [defaults synchronize];
            
        }
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
        SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;

    NSLog(@"ViewController viewDidLoad");


}



-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");

    // Create and configure the scene.

    SKView *newView = (SKView *) self.view;
    scene=[[MyScene alloc]initWithSize:newView.bounds.size];
    //scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"loadEnd" object:nil];
    
    [newView presentScene:scene];

    [self retrievePlayerScore];
    
        [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(appWillEnterBackground)
     name:UIApplicationWillResignActiveNotification
     object:NULL];
}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"loadEnd"]) {
        NSLog(@"loadEnd received!");
        UIWindow *window = self.view.window;
        [self dismissViewControllerAnimated:YES completion:nil];
        EndViewController *gameNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"EndViewController"];
        window.rootViewController = gameNavController;
    }
}

- (void)appWillEnterBackground
{
   SKView *skView = (SKView *)self.view;
   skView.paused = YES;
    
    bubbleOn=NO;
    NSLog(@"ViewController appWillEnterBackground");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopBubbles" object:nil];

    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(appWillEnterForeground)
     name:UIApplicationDidBecomeActiveNotification
     object:NULL];
    
}


- (void)appWillEnterForeground
{
    SKView * skView = (SKView *)self.view;
    
    skView.paused=NO;
    
   
    NSLog(@"ViewController appWillEnterForeground");
   //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(appWillEnterBackground)
     name:UIApplicationWillResignActiveNotification
     object:NULL];
    NSLog(@"BUBBLE %i",bubbleOn);
    
    if (gameOver==YES) {
        return;
    } else {
        if (bubbleOn==NO){
   bubbleOn=YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startBubbles" object:nil];

    }
 
    }
}



- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
