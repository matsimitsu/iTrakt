#import <UIKit/UIKit.h>
#import "AsyncImageTableViewController.h"
#import "Episode.h"

@interface CalendarViewController : AsyncImageTableViewController {
  NSArray *broadcastDates;
  UISearchBar *searchBar;
  UISearchDisplayController *searchController;
}

@property (nonatomic, retain) NSArray *broadcastDates;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchController;

@end
