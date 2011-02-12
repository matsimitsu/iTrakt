#import "ShowTableViewCell.h"

// Posters are 138x203, hence for every ASPECT_RATIO pixels in width there is 1 pixel in height
#define POSTER_ASPECT_RATIO 0.679802955665025

#define MARGIN 8.0

@implementation ShowTableViewCell

@synthesize show;
@synthesize imageView;
@synthesize titleLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    self.imageView = [UIImageView new];
    self.imageView.opaque = YES;
    [self.contentView addSubview:self.imageView];

    self.titleLabel = [UILabel new];
    self.titleLabel.opaque = YES;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    [self.contentView addSubview:titleLabel];
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
  } else {
    self.titleLabel.textColor = [UIColor blackColor];
  }

  CGSize size = self.bounds.size;

  CGFloat x = 0.0;
  CGFloat y = 0.0;
  CGFloat imageWidth, labelWidth, labelHeight;

  imageWidth = floor(size.height * POSTER_ASPECT_RATIO);
  CGSize imageSize = CGSizeMake(imageWidth, size.height);

  self.imageView.image = self.show.poster;
  self.imageView.frame = CGRectMake(x, y, imageSize.width, imageSize.height);

  x += imageWidth + MARGIN;
  labelWidth = size.width - x;
  labelHeight = [UIFont systemFontSize];
  self.titleLabel.text = self.show.title;
  self.titleLabel.frame = CGRectMake(x, (size.height - labelHeight) / 2.0, labelWidth, labelHeight);
}


- (void)dealloc {
  [super dealloc];
  [show release];
  [imageView release];
  [titleLabel release];
}


@end
