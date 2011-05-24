#import "ImageRootController.h"
#import "HTTPDownload.h"

#define ROW_HEIGHT 66.0

@implementation ImageRootController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.rowHeight = ROW_HEIGHT;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  dragging = NO;
  [self loadImagesForVisibleCells];
}

// The subclass should override this to actually set the data before calling super.
- (void)reloadTableViewData:(NSArray *)data {
  [super reloadTableViewData:data]; // first reload!
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  dragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  dragging = NO;
  [self loadImagesForVisibleCells];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    dragging = NO;
    [self loadImagesForVisibleCells];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (!dragging) {
    [self loadImagesForVisibleCells];
  }
}

@end
