#import "LibraryViewController.h"
#import "Trakt.h"

@implementation LibraryViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"Library";

  // TODO this probably has to move to viewDidAppear so that it gets run whenever this view is shown, not just the first time!
  [[Trakt sharedInstance] library:^(NSArray *_shows) {
    self.shows = _shows;
    [self reloadTableViewData];
  }];
}


@end
