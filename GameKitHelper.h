//
//  GameKitHelper.h
//  BubbleTile
//
@import GameKit;

@interface GameKitHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;
@property (nonatomic, strong) NSString *leaderboardIdentifier;
extern BOOL _enableGameCenter;
extern BOOL patchedAuthenticate;
+ (instancetype)sharedGameKitHelper;
extern NSString *const PresentAuthenticationViewController;
extern NSString *const LocalPlayerIsAuthenticated;
- (void)authenticateLocalPlayer;

@end
