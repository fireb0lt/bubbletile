//
//  GameNavigationController.m
//  BubbleTile
//

#import "GameNavigationController.h"
#import "GameKitHelper.h"

@implementation GameNavigationController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    }

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showAuthenticationViewController)
     name:PresentAuthenticationViewController
     object:nil];
    
    [[GameKitHelper sharedGameKitHelper]
     authenticateLocalPlayer];

}

- (void)showAuthenticationViewController
{
    GameKitHelper *gameKitHelper =
    [GameKitHelper sharedGameKitHelper];
    
    [self.topViewController presentViewController:
     gameKitHelper.authenticationViewController
     animated:YES
     completion:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

