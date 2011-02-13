#import "AsyncImageTableViewController.h"
#import "HTTPDownload.h"

@implementation AsyncImageTableViewController


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self loadImagesForVisibleCells];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [HTTPDownload cancelDownloadsInProgress];
}


- (void)reloadTableViewData {
  [self.tableView reloadData];
  [self loadImagesForVisibleCells];
}


- (void)loadImageForCell:(UITableViewCell *)cell {
  NSLog(@"[!] The [AsyncImageTableViewController loadImageForCell:] method should be overriden by the subclass!");
}


- (void)loadImagesForVisibleCells {
  NSArray *cells = [self.tableView visibleCells];
  for (int i = 0; i < [cells count]; i++) {
    [self loadImageForCell:[cells objectAtIndex:i]];
  }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self loadImagesForVisibleCells];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    [self loadImagesForVisibleCells];
  }
}


@end
