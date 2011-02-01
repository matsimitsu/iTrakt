#import <UIKit/UIKit.h>
#import "Episode.h"

@interface CalendarViewController : UITableViewController {
  NSArray *broadcastDates;
}

@property (nonatomic, retain) NSArray *broadcastDates;

@end
