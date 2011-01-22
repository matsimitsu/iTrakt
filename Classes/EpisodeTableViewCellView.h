#import <UIKit/UIKit.h>
#import "Episode.h"

@interface EpisodeTableViewCellView : UIView {
  Episode *episode;
  UIImageView *imageView;
}

@property (nonatomic, retain) Episode *episode;
@property (nonatomic, retain) UIImageView *imageView;

@end
