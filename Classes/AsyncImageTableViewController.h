#import <UIKit/UIKit.h>

@interface AsyncImageTableViewController : UITableViewController {
  BOOL dragging;
}

- (void)reloadTableViewData;
- (void)loadImagesForVisibleCells;
- (void)loadImageForCell:(UITableViewCell *)cell;

@end
