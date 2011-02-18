#import <UIKit/UIKit.h>
#import "AsyncImageTableViewController.h"
#import "Episode.h"

@interface CalendarViewController : AsyncImageTableViewController <UISearchDisplayDelegate> {
  NSArray *broadcastDates;
  NSMutableArray *filteredListContent;
  UISearchBar *searchBar;
  UISearchDisplayController *searchController;
}

@property (nonatomic, retain) NSArray *broadcastDates;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchController;

@end
