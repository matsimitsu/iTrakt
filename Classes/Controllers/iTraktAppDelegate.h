#import <UIKit/UIKit.h>
#import "HTTPDownload.h"
#import "AuthenticationViewController.h"

@interface iTraktAppDelegate : NSObject <UIApplicationDelegate, AuthenticationViewControllerDelegate> {
  BOOL refreshDataWhenAuthViewDismisses;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (void)downloadsAreInProgress;
- (void)downloadsAreFinished;
- (void)downloadFailed:(HTTPDownload *)download;

- (void)refreshDataStartingAtCurrentSelectedTopLevelController;

- (IBAction)presentAuthenticationDialog:(id)sender;

@end

