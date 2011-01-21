#import "EpisodeTableViewCell.h"

@implementation EpisodeTableViewCell

@synthesize episodeView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.episodeView = [[EpisodeTableViewCellView alloc] initWithFrame:self.contentView.frame];
    [self.contentView addSubview:episodeView];
  }
  return self;
}

-(void)setEpisode:(Episode *)episode {
  episodeView.episode = episode;
}

- (void)redisplay {
  [episodeView setNeedsDisplay];
}

- (void)dealloc {
  [super dealloc];
  [episodeView dealloc];
}

@end
