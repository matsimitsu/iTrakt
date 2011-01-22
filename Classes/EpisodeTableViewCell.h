#import <UIKit/UIKit.h>
#import "Episode.h"

@interface EpisodeTableViewCell : UITableViewCell {
  Episode *episode;
  UIImageView *imageView;
}

@property (nonatomic, retain) Episode *episode;
@property (nonatomic, retain) UIImageView *imageView;

+ (CGFloat)imageViewHeightForWidth:(CGFloat)width;
+ (CGFloat)heightForWidth:(CGFloat)width;

@end
