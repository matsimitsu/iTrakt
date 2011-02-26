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

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.imageView = [UIImageView new];
    self.imageView.opaque = YES;
    [self.contentView addSubview:self.imageView];

    self.serieTitleAndEpisodeNumberLabel = [UILabel new];
    self.serieTitleAndEpisodeNumberLabel.opaque = YES;
    self.serieTitleAndEpisodeNumberLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    [self.contentView addSubview:serieTitleAndEpisodeNumberLabel];

    self.titleLabel = [UILabel new];
    self.titleLabel.opaque = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    [self.contentView addSubview:titleLabel];

    self.airTimeAndChannelLabel = [UILabel new];
    self.airTimeAndChannelLabel.opaque = YES;
    self.airTimeAndChannelLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    [self.contentView addSubview:airTimeAndChannelLabel];
  }
  return self;
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    //[super setSelected:selected animated:animated];

    //// Configure the view for the selected state.
//}


- (void)layoutSubviews {
  [super layoutSubviews];

  if (self.selected) {
    self.titleLabel.textColor = [UIColor whiteColor];
    self.airTimeAndChannelLabel.textColor = [UIColor whiteColor];
    self.serieTitleAndEpisodeNumberLabel.textColor = [UIColor whiteColor];
  } else {
    self.serieTitleAndEpisodeNumberLabel.textColor = [UIColor blackColor];
    self.titleLabel.textColor = [UIColor grayColor];
    self.airTimeAndChannelLabel.textColor = [UIColor grayColor];
  }

  CGSize size = self.bounds.size;

  CGFloat x = 0.0;
  CGFloat y = 0.0;
  CGFloat imageWidth, labelWidth, labelHeight;

  imageWidth = floor(size.height * POSTER_ASPECT_RATIO);
  CGSize imageSize = CGSizeMake(imageWidth, size.height);

  self.imageView.image = self.episode.poster;
  self.imageView.frame = CGRectMake(x, y, imageSize.width, imageSize.height);

  x += imageWidth + MARGIN;
  y += MARGIN;
  labelWidth = size.width - x;
  labelHeight = [UIFont systemFontSize] + MARGIN_UNDERNEATH_LABEL;
  self.serieTitleAndEpisodeNumberLabel.text = [self.episode serieTitleAndEpisodeNumber];
  self.serieTitleAndEpisodeNumberLabel.frame = CGRectMake(x, y, labelWidth, labelHeight);


  y += labelHeight + MARGIN_UNDERNEATH_LABEL;
  labelHeight = [UIFont smallSystemFontSize] + MARGIN_UNDERNEATH_LABEL;
  self.titleLabel.text = self.episode.title;
  self.titleLabel.frame = CGRectMake(x, y, labelWidth, labelHeight);

  y += labelHeight + MARGIN_UNDERNEATH_LABEL;
  self.airTimeAndChannelLabel.text = [self.episode airTimeAndChannel];
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
