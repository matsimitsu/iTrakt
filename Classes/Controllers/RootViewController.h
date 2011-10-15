#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
  NSString *feedSelector, *cachedFeedProperty;
}

@property (nonatomic, retain) NSString *feedSelector, *cachedFeedProperty;

- (void)refreshData;
- (void)checkAuth;
- (void)reloadTableViewData:(NSArray *)data;
- (void)showRefreshDataButton;
- (void)showStopRefreshDataButton;
- (void)cancelRefreshData;
@end
