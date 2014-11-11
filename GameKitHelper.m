//
//  GameKitHelper.m
//  BubbleTile
//
//  Created by Isaac on 7/10/14.
//  Copyright (c) 2014 Isaac. All rights reserved.
//

#import "GameKitHelper.h"

@implementation GameKitHelper {
    
}
BOOL _enableGameCenter;
BOOL patchedAuthenticate;
NSString *leaderboardIdentifier =@"highScore01";
NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";
NSString *const LocalPlayerIsAuthenticated = @"local_player_authenticated";

+ (instancetype)sharedGameKitHelper
{
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;

}

- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    } else {
        _enableGameCenter=NO;
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    //1
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    //2
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        //3
        _enableGameCenter = NO;
        [self setLastError:error];
        
        if(viewController != nil) {
            //4
            _enableGameCenter = NO;
            [self setAuthenticationViewController:viewController];
            
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            //5
            patchedAuthenticate=YES;
            _enableGameCenter = YES;
            
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                
                if (error != nil) {
                    NSLog(@"tttttt %@", [error localizedDescription]);
                }
                else{
                    _leaderboardIdentifier = leaderboardIdentifier;
                }
            }];
        } else {
            //6
            _enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PresentAuthenticationViewController
         object:self];
        
    }
}


- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",
              [[_lastError userInfo] description]);
    }
}




















@end
