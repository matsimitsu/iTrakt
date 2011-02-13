#import <UIKit/UIKit.h>

@interface iTraktAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IBOutlet UITabBarController* tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (void)downloadsAreInProgress;
- (void)downloadsAreFinished;

@end

