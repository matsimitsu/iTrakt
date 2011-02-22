#import "TrendingViewController.h"
#import "Trakt.h"

@implementation TrendingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
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
  [[Trakt sharedInstance] retrieveTopLevelControllerdataStartingWith:@"trending:" block:^(NSArray *loadedShows) {
    self.shows = loadedShows;
    [self reloadTableViewData];
  }];
}

@end
