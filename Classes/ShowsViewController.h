#import <UIKit/UIKit.h>

@interface ShowsViewController : UITableViewController {
  NSArray *shows;
}

@property (nonatomic, retain) NSArray *shows;

- (void)reloadTableViewData;
- (void)loadImagesForVisibleCells;
- (void)loadImageForCell:(UITableViewCell *)cell;

@end
