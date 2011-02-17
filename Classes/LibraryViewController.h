#import <UIKit/UIKit.h>
#import "ShowsViewController.h"
#import "ShowDetailsViewController.h"

#import "Trakt.h"
#import "Show.h"

@interface LibraryViewController : UITableViewController {
  NSArray *shows;
}

@property (nonatomic, retain) NSArray *shows;

@end
