#import "TrendingViewController.h"
#import "Trakt.h"

@implementation TrendingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"Trending";

  // TODO this probably has to move to viewDidAppear so that it gets run whenever this view is shown, not just the first time!
  [[Trakt sharedInstance] trending:^(NSArray *_shows) {
    self.shows = _shows;
    [self reloadTableViewData];
  }];
}

@end
