#import "RootViewController.h"
#import "Trakt.h"
#import "HTTPDownload.h"

@implementation RootViewController

@synthesize feedSelector, cachedFeedProperty;

- (void)dealloc {
  [feedSelector release];
  [cachedFeedProperty release];
  [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
  NSString *username = [Trakt sharedInstance].apiUser;
  self.navigationItem.rightBarButtonItem.title = username == nil ? @"Sign in" : username;

  if ([self valueForKey:cachedFeedProperty] == nil) {
    id data = [[Trakt sharedInstance] valueForKey:cachedFeedProperty];
    if (data) {
      [self reloadTableViewData:data];
    }
  }

  [super viewWillAppear:animated];
}

- (void)refreshData {
  [self showStopRefreshDataButton];
  [[Trakt sharedInstance] retrieveRootControllerDataStartingWith:feedSelector block:^(NSArray *data) {
    [self showRefreshDataButton];
    [self reloadTableViewData:data];
  }];
}

// Implemented by the subclass
- (void)reloadTableViewData:(NSArray *)data {
  [self.tableView reloadData];
}

- (void)showRefreshDataButton {
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(refreshData)];
  self.navigationItem.leftBarButtonItem = refreshButton;
  [refreshButton release];
}

- (void)showStopRefreshDataButton {
  UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                              target:self
                                                                              action:@selector(cancelRefreshData)];
  self.navigationItem.leftBarButtonItem = stopButton;
  [stopButton release];
}

- (void)cancelRefreshData {
  [self showRefreshDataButton];
  [HTTPDownload cancelDownloadsInProgress];
}

@end
