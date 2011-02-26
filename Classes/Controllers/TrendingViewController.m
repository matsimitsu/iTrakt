#import "TrendingViewController.h"
#import "Trakt.h"
#import "HTTPDownload.h"

@implementation TrendingViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self showRefreshDataButton];
  self.navigationItem.title = @"Trending";
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (self.shows == nil && [Trakt sharedInstance].trending != nil) {
    NSLog(@"Loading trending data from Trakt instance which has already loaded it");
    self.shows = [Trakt sharedInstance].trending;
    [self reloadTableViewData];
  }
}


- (void)refreshData {
  NSLog(@"Refresh trending data!");
  [self showStopRefreshDataButton];
  [[Trakt sharedInstance] retrieveTopLevelControllerdataStartingWith:@"trending:" block:^(NSArray *loadedShows) {
    [self showRefreshDataButton];
    self.shows = loadedShows;
    [self reloadTableViewData];
  }];
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
