#import <UIKit/UIKit.h>
#import "Episode.h"

@class Checkbox;

@interface EpisodeDetailsViewController : UITableViewController {
  Episode *episode;

  UITableViewCell *bannerCell;
  UIImageView *bannerView;

  UITableViewCell *titleAndEpisodeAndSeasonCell;
  Checkbox *seenCheckbox;
  UILabel *titleLabel;
  UILabel *episodeAndSeasonLabel;

  UITableViewCell *overviewCell;
  UILabel *overviewLabel;

  UITableViewCell *showDetailsCell;
  UILabel *showTitleLabel;
}

@property (nonatomic, retain) Episode *episode;

@property (nonatomic, retain) IBOutlet UITableViewCell *bannerCell;
@property (nonatomic, retain) IBOutlet UIImageView *bannerView;

@property (nonatomic, retain) IBOutlet UITableViewCell *titleAndEpisodeAndSeasonCell;
@property (nonatomic, retain) IBOutlet Checkbox *seenCheckbox;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *episodeAndSeasonLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell *overviewCell;
@property (nonatomic, retain) IBOutlet UILabel *overviewLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell *showDetailsCell;
@property (nonatomic, retain) IBOutlet UILabel *showTitleLabel;

- (id)initWithEpisode:(Episode *)theEpisode;

@end
