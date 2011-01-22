#import <UIKit/UIKit.h>
#import "Episode.h"

@interface EpisodeTableViewCell : UITableViewCell {
  Episode *episode;
  UIImageView *imageView;
  UILabel *numberLabel;
  UILabel *titleLabel;
}

@property (nonatomic, retain) Episode *episode;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *numberLabel;
@property (nonatomic, retain) UILabel *titleLabel;

+ (CGFloat)imageViewHeightForWidth:(CGFloat)width;
+ (CGFloat)heightForWidth:(CGFloat)width;

@end
