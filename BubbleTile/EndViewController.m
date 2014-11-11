//
//  EndViewController.m
//  BubbleTile
//
//  Created by Isaac on 7/23/14.
//  Copyright (c) 2014 Isaac. All rights reserved.
//

#import "EndViewController.h"

@interface EndViewController ()

@end

@implementation EndViewController
- (BOOL) prefersStatusBarHidden{
    return YES;
}
NSUserDefaults *defaults;
SKScene * scene;
NSTimer *myTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"loadStart"]) {
        UIWindow *window = self.view.window;
        
        GameNavigationController *gameNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        window.rootViewController = gameNavController;
    }
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [banner setAlpha:1];
    [UIView commitAnimations];
    
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [banner setAlpha:0];
    [UIView commitAnimations];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"loadStart" object:nil];
    // Create and configure the scene.
    
    SKView *newView = (SKView *) self.view;
    scene=[[GameOverScene alloc]initWithSize:newView.bounds.size];

    scene.scaleMode = SKSceneScaleModeAspectFill;

    
    [newView presentScene:scene];
    

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
