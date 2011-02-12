#import <UIKit/UIKit.h>

@interface AsyncImageTableViewController : UITableViewController {

}

- (void)reloadTableViewData;
- (void)loadImagesForVisibleCells;
- (void)loadImageForCell:(UITableViewCell *)cell;

@end
