#import "EpisodeTableViewCell.h"

// Banners are 758x140, hence for every ASPECT_RATIO pixels in width there is 1 pixel in height
#define ASPECT_RATIO 5.414285714285714

#define MARGIN_AROUND_TITLE 2

@implementation EpisodeTableViewCell

@synthesize episode;
@synthesize imageView;

+ (CGFloat)imageViewHeightForWidth:(CGFloat)width {
  return (CGFloat)floor(width / ASPECT_RATIO);
}

+ (CGFloat)heightForWidth:(CGFloat)width {
   return [EpisodeTableViewCell imageViewHeightForWidth:width] + [UIFont smallSystemFontSize] + (MARGIN_AROUND_TITLE * 2);
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    NSLog(@"Cell init with frame %@", NSStringFromCGRect(frame));
    self.imageView = [UIImageView new];
    [self.contentView addSubview:self.imageView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  NSLog(@"Layout content view with frame %@", NSStringFromCGRect(self.contentView.bounds));

  self.imageView.image = episode.banner;
  self.imageView.frame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, [EpisodeTableViewCell imageViewHeightForWidth:self.contentView.bounds.size.width]);
}

//- (void)dealloc {
  //[super dealloc];
//}

@end
