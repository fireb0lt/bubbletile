//
//  ViewController.h
//  BubbleTile
//

//  Copyright (c) 2014 Isaac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "MyScene.h"
#import "GameOverScene.h"
#import "GameKitHelper.h"
#import "GameNavigationController.h"
#import <iAd/iAd.h>
#import "EndViewController.h"
@interface ViewController : UIViewController <ADBannerViewDelegate>

- (void)appWillEnterForeground;
-(void)reportScore;
-(void)viewDidLoad;


@end
