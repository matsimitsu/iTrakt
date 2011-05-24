#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface LibraryViewController : RootViewController <UISearchDisplayDelegate> {
  NSMutableArray *library;
  NSMutableArray *filteredShows;
  NSMutableArray *indexTitles;
  UISearchBar *searchBar;
  UISearchDisplayController *searchController;
}

@property (nonatomic, retain) NSMutableArray *library;
@property (nonatomic, retain) NSMutableArray *filteredShows;
@property (nonatomic, retain) NSMutableArray *indexTitles;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchController;

@end
