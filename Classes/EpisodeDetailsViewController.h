#import <UIKit/UIKit.h>
#import "Episode.h"

@interface EpisodeDetailsViewController : UIViewController {
  Episode *episode;
}

@property (nonatomic, retain) Episode *episode;

- (id)initWithEpisode:(Episode *)theEpisode;

@end
