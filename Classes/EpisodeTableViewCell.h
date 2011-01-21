#import <UIKit/UIKit.h>
#import "EpisodeTableViewCellView.h"
#import "Episode.h"

@interface EpisodeTableViewCell : UITableViewCell {
  EpisodeTableViewCellView *episodeView;
}

@property (nonatomic, retain) EpisodeTableViewCellView *episodeView;

-(void)setEpisode:(Episode *)episode;

@end
