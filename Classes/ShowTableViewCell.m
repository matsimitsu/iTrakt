#import "ShowTableViewCell.h"

// Posters are 138x203, hence for every ASPECT_RATIO pixels in width there is 1 pixel in height
#define POSTER_ASPECT_RATIO 0.679802955665025

#define MARGIN 8.0
#define MARGIN_UNDERNEATH_LABEL 2.0
#define INDICATORWIDTH 18.0

@implementation ShowTableViewCell

@synthesize show;
@synthesize imageView;
@synthesize titleLabel;
@synthesize excerptLabel;
@synthesize watchersLabel;

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

    self.excerptLabel = [UILabel new];
    self.excerptLabel.opaque = YES;
    self.excerptLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    [self.contentView addSubview:excerptLabel];

    self.watchersLabel = [UILabel new];
    self.watchersLabel.opaque = YES;
    self.watchersLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    [self.contentView addSubview:watchersLabel];

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
    self.excerptLabel.textColor = [UIColor whiteColor];
    self.watchersLabel.textColor = [UIColor whiteColor];
  } else {
    self.titleLabel.textColor = [UIColor blackColor];
    self.excerptLabel.textColor = [UIColor grayColor];
    self.watchersLabel.textColor = [UIColor grayColor];
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
  y += MARGIN;
  labelWidth = (size.width - x) - INDICATORWIDTH;
  labelHeight = [UIFont systemFontSize] + MARGIN_UNDERNEATH_LABEL;
  self.titleLabel.text = self.show.title;
  self.titleLabel.frame = CGRectMake(x, y, labelWidth, labelHeight);


  y += labelHeight + MARGIN_UNDERNEATH_LABEL;
  labelHeight = [UIFont smallSystemFontSize] + MARGIN_UNDERNEATH_LABEL;
  self.excerptLabel.text = self.show.overview;
  self.excerptLabel.frame = CGRectMake(x, y, labelWidth, labelHeight);

  y += labelHeight + MARGIN_UNDERNEATH_LABEL;
  self.watchersLabel.text = [NSString stringWithFormat:(self.show.watchers == 1) ? @"%d Watcher" : @"%d Watchers", self.show.watchers, nil];
  self.watchersLabel.frame = CGRectMake(x, y, labelWidth, labelHeight);

}

- (void)dealloc {
  [super dealloc];
  [show release];
  [imageView release];
  [titleLabel release];
  [excerptLabel release];
  [watchersLabel release];
}


@end
