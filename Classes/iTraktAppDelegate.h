#import <UIKit/UIKit.h>
#import "HTTPDownload.h"

@interface iTraktAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  IBOutlet UITabBarController* tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (void)downloadsAreInProgress;
- (void)downloadsAreFinished;
- (void)downloadFailed:(HTTPDownload *)download;

- (void)refreshDataStartingAtCurrentSelectedTopLevelController;

@end

