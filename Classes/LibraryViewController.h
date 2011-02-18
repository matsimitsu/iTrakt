#import <UIKit/UIKit.h>
#import "ShowsViewController.h"
#import "ShowDetailsViewController.h"

#import "Trakt.h"
#import "Show.h"

@interface LibraryViewController : UITableViewController <UISearchDisplayDelegate> {
  NSMutableArray *shows;
  NSMutableArray *filteredShows;
  NSMutableArray *indexTitles;
  UISearchBar *searchBar;
  UISearchDisplayController *searchController;
}

@property (nonatomic, retain) NSMutableArray *shows;
@property (nonatomic, retain) NSMutableArray *filteredShows;
@property (nonatomic, retain) NSMutableArray *indexTitles;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchController;

@end
