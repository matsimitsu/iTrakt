#import <UIKit/UIKit.h>
#import "Episode.h"

@interface EpisodeTableViewCell : UITableViewCell {
  Episode *episode;
  UIImageView *imageView;

  UILabel *titleLabel;
  UILabel *airtimeAndChannelLabel;
  UILabel *serieTitleAndEpisodeNumberLabel;
}

@property (nonatomic, retain) Episode *episode;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *airtimeAndChannelLabel;
@property (nonatomic, retain) UILabel *serieTitleAndEpisodeNumberLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
