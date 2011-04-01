#import "RecommendationsViewController.h"
#import "Trakt.h"
#import "HTTPDownload.h"

@implementation RecommendationsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self showRefreshDataButton];
  self.navigationItem.title = @"Recommended";
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  // TODO This should be done in one place (superclass)
  NSString *username = [Trakt sharedInstance].apiUser;
  self.navigationItem.rightBarButtonItem.title = username == nil ? @"Sign in" : username;

  if (self.shows == nil && [Trakt sharedInstance].recommendations != nil) {
    NSLog(@"Loading recommendations data from Trakt instance which has already loaded it");
    self.shows = [Trakt sharedInstance].recommendations;
    [self reloadTableViewData];
  }
}


- (void)refreshData {
  NSLog(@"Refresh recommendations data!");
  [self showStopRefreshDataButton];
  [[Trakt sharedInstance] retrieveTopLevelControllerdataStartingWith:@"recommendations:" block:^(NSArray *loadedShows) {
    [self showRefreshDataButton];
    self.shows = loadedShows;
    [self reloadTableViewData];
  }];
}


// TODO This should be done in one place (superclass)
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
