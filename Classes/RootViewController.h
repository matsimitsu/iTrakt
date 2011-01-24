#import <UIKit/UIKit.h>
#import "Episode.h"

@interface RootViewController : UITableViewController {
  NSArray *broadcastDates;
}

@property (nonatomic, retain) NSArray *broadcastDates;

- (void)datesLoaded:(NSArray *)dates;
- (void)episodeDidLoadPoster:(Episode *)episode;

@end
