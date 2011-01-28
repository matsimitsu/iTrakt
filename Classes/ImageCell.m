#import "ImageCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageCell

@synthesize image;
@synthesize imageView;


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.imageView = [UIImageView new];
    self.imageView.opaque = YES;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 10.0;
    //self.imageView.layer.minificationFilter = kCAFilterTrilinear;
    [self.contentView addSubview:self.imageView];
  }
  return self;
}


- (void)dealloc {
  [super dealloc];
  [image release];
  [imageView release];
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    //[super setSelected:selected animated:animated];
    
    //// Configure the view for the selected state.
//}


- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect frame = self.bounds;
  frame.size.width -= (2 * self.indentationWidth);
  frame.size.height -= 2.0;

  self.imageView.image = self.image;
  self.imageView.frame = frame;
}

@end
