#import "EpisodeTableViewCell.h"

// Posters are 138x203, hence for every ASPECT_RATIO pixels in width there is 1 pixel in height
#define POSTER_ASPECT_RATIO 0.679802955665025

#define MARGIN 8.0

#define MARGIN_UNDERNEATH_LABEL 2.0

@implementation EpisodeTableViewCell

@synthesize episode;
@synthesize imageView;

@synthesize titleLabel;
@synthesize airTimeAndChannelLabel;
@synthesize serieTitleAndEpisodeNumberLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    self.imageView = [UIImageView new];
    self.imageView.opaque = YES;
    [self.contentView addSubview:self.imageView];

    self.titleLabel = [UILabel new];
    self.titleLabel.opaque = YES;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    [self.contentView addSubview:titleLabel];

    self.serieTitleAndEpisodeNumberLabel = [UILabel new];
    self.serieTitleAndEpisodeNumberLabel.textColor = [UIColor grayColor];
    self.serieTitleAndEpisodeNumberLabel.opaque = YES;
    self.serieTitleAndEpisodeNumberLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    [self.contentView addSubview:serieTitleAndEpisodeNumberLabel];

    self.airTimeAndChannelLabel = [UILabel new];
    self.airTimeAndChannelLabel.textColor = [UIColor grayColor];
    self.airTimeAndChannelLabel.opaque = YES;
    self.airTimeAndChannelLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    [self.contentView addSubview:airTimeAndChannelLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGSize size = self.bounds.size;

  CGFloat x = 0.0;
  CGFloat y = 0.0;
  CGFloat imageWidth, labelWidth, labelHeight;

  imageWidth = size.height * POSTER_ASPECT_RATIO;
  self.imageView.image = episode.poster;
  self.imageView.frame = CGRectMake(x, y, imageWidth, size.height);

  x += imageWidth + MARGIN;
  y += MARGIN;
  labelWidth = size.width - x;
  labelHeight = [UIFont systemFontSize] + MARGIN_UNDERNEATH_LABEL;
  self.titleLabel.text = episode.title;
  self.titleLabel.frame = CGRectMake(x, y, labelWidth, labelHeight);

  y += labelHeight + MARGIN_UNDERNEATH_LABEL;
  labelHeight = [UIFont smallSystemFontSize] + MARGIN_UNDERNEATH_LABEL;
  self.serieTitleAndEpisodeNumberLabel.text = [episode serieTitleAndEpisodeNumber];
  self.serieTitleAndEpisodeNumberLabel.frame = CGRectMake(x, y, labelWidth, labelHeight);

  y += labelHeight + MARGIN_UNDERNEATH_LABEL;
  self.airTimeAndChannelLabel.text = [episode airTimeAndChannel];
  self.airTimeAndChannelLabel.frame = CGRectMake(x, y, labelWidth, labelHeight);
}

- (void)dealloc {
  [super dealloc];
  [imageView release];
  [titleLabel release];
  [airTimeAndChannelLabel release];
  [serieTitleAndEpisodeNumberLabel release];
}

@end
