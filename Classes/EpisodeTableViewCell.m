#import "EpisodeTableViewCell.h"

// Banners are 758x140, hence for every ASPECT_RATIO pixels in width there is 1 pixel in height
#define ASPECT_RATIO 5.414285714285714

#define MARGIN_AROUND_TITLE 2

@implementation EpisodeTableViewCell

@synthesize episode;
@synthesize imageView;
@synthesize titleLabel;

+ (CGFloat)imageViewHeightForWidth:(CGFloat)width {
  return (CGFloat)floor(width / ASPECT_RATIO);
}

+ (CGFloat)heightForWidth:(CGFloat)width {
   return [EpisodeTableViewCell imageViewHeightForWidth:width] + [UIFont smallSystemFontSize] + (MARGIN_AROUND_TITLE * 2);
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    self.imageView = [UIImageView new];
    self.imageView.opaque = YES;
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.opaque = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.titleLabel.textAlignment = UITextAlignmentRight;
    [self.contentView addSubview:titleLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGFloat width = self.contentView.bounds.size.width;
  CGFloat imageViewHeight = [EpisodeTableViewCell imageViewHeightForWidth:width];

  self.imageView.image = episode.banner;
  self.imageView.frame = CGRectMake(0.0, 0.0, width, imageViewHeight);

  self.titleLabel.text = episode.title;
  self.titleLabel.frame = CGRectMake(0.0, imageViewHeight, width, [UIFont smallSystemFontSize] + (MARGIN_AROUND_TITLE * 2));
}

//- (void)dealloc {
  //[super dealloc];
//}

@end
