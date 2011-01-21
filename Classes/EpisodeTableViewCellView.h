#import <UIKit/UIKit.h>
#import "Episode.h"

@interface EpisodeTableViewCellView : UIView {
  Episode *episode;
}

@property (nonatomic, retain) Episode *episode;

@end
