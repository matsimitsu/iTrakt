#import "EpisodeTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"

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
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    self.imageView = [UIImageView new];
    self.imageView.opaque = YES;
    //self.imageView.layer.minificationFilter = kCAFilterTrilinear;
    [self.contentView addSubview:self.imageView];

    self.titleLabel = [UILabel new];
    self.titleLabel.opaque = YES;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    [self.contentView addSubview:titleLabel];

    self.serieTitleAndEpisodeNumberLabel = [UILabel new];
    self.serieTitleAndEpisodeNumberLabel.opaque = YES;
    self.serieTitleAndEpisodeNumberLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    [self.contentView addSubview:serieTitleAndEpisodeNumberLabel];

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
    self.titleLabel.textColor = [UIColor blackColor];
    self.airTimeAndChannelLabel.textColor = [UIColor grayColor];
    self.serieTitleAndEpisodeNumberLabel.textColor = [UIColor grayColor];
  }

  CGSize size = self.bounds.size;

  CGFloat x = 0.0;
  CGFloat y = 0.0;
  CGFloat imageWidth, labelWidth, labelHeight;

  imageWidth = size.height * POSTER_ASPECT_RATIO;
  CGSize imageSize = CGSizeMake(imageWidth, size.height);

  // TODO This should happen only once and then be cached on the Episode instance!
  self.imageView.image = [[episode.poster normalize] resizedImage:imageSize interpolationQuality:kCGInterpolationHigh];
  //self.imageView.image = episode.posterThumbnail;
  self.imageView.frame = CGRectMake(x, y, imageSize.width, imageSize.height);

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
