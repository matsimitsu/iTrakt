#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface ImageRootController : RootViewController {
  BOOL dragging;
}

- (void)loadImagesForVisibleCells;
- (void)loadImageForCell:(UITableViewCell *)cell;

@end
