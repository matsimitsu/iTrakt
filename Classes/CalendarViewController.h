#import <UIKit/UIKit.h>
#import "AsyncImageTableViewController.h"
#import "Episode.h"

@interface CalendarViewController : AsyncImageTableViewController {
  NSArray *broadcastDates;
}

@property (nonatomic, retain) NSArray *broadcastDates;

@end
