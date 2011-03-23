#import "iTraktAppDelegate.h"
#import "Trakt.h"
#import "CalendarViewController.h"
#import "AuthenticationViewController.h"

// ONLY FOR DEBUGGING PURPOSES!
#import "Authentication.h"
#import "EGOCache.h"

@implementation iTraktAppDelegate

@synthesize window;
@synthesize tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // ONLY FOR DEBUGGING PURPOSES!
  //NSLog(@"[!] Clearing cache");
  //[[EGOCache currentCache] clearCache];

  if ([AuthenticationViewController signIn]) {
    NSLog(@"Signed in.");
  } else {
    NSLog(@"Not signed in.");
  }

  [[Trakt sharedInstance] setApiKey:API_KEY];

  [HTTPDownload setGlobalDelegate:self];

  [self.window makeKeyAndVisible];

  // Give the controller a chance to initialize
  [self performSelector:@selector(refreshDataStartingAtCurrentSelectedTopLevelController) withObject:nil afterDelay:0];

  return YES;
}


- (void)downloadsAreInProgress {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)downloadsAreFinished {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)downloadFailed:(HTTPDownload *)download {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failure"
                                          message:[download errorMessage]
                                         delegate:nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
  [alert show];
  [alert release];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  NSLog(@"App became active!");
  [self refreshDataStartingAtCurrentSelectedTopLevelController];
}

- (void)refreshDataStartingAtCurrentSelectedTopLevelController {
  NSLog(@"Refresh data!");
  UIViewController *controller = ((UINavigationController *)self.tabBarController.selectedViewController).topViewController;
  if (controller) {
    NSLog(@"Selected controller: %@", controller);
    // TODO we should not use performSelector for this, but have all top-level controllers inherit from one class which implements the method!
    [controller performSelector:@selector(refreshData)];
  }
}


- (IBAction)presentAuthenticationDialog:(id)sender {
  AuthenticationViewController *controller = [[AuthenticationViewController alloc] initWithNibName:@"AuthenticationViewController" bundle:nil];
  NSLog(@"root: %@ Present: %@", self.window.rootViewController, controller);
  [self.window.rootViewController presentModalViewController:controller animated:YES];
  [controller release];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[tabBarController release];
	[window release];
	[super dealloc];
}


@end

