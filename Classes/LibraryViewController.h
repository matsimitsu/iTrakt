#import <UIKit/UIKit.h>
#import "ShowsViewController.h"
#import "ShowDetailsViewController.h"

#import "Trakt.h"
#import "Show.h"

@interface LibraryViewController : UITableViewController <UISearchDisplayDelegate> {
  NSArray *shows;
  NSMutableArray *filteredShows;
  UISearchBar *searchBar;
  UISearchDisplayController *searchController;
}

@property (nonatomic, retain) NSArray *shows;
@property (nonatomic, retain) NSArray *filteredShows;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchController;

@end
