#import <UIKit/UIKit.h>
#import "Show.h"

@interface ShowDetailsViewController : UITableViewController {
  Show *show;

  UITableViewCell *bannerCell;
  UIImageView *bannerView;

  UITableViewCell *titleAndSeasonsAndEpisodesCell;
  UILabel *titleLabel;
  UILabel *seasonsAndEpisodesLabel;

  UITableViewCell *overviewCell;
  UILabel *overviewLabel;
}

@property (nonatomic, retain) Show *show;

@property (nonatomic, retain) IBOutlet UITableViewCell *bannerCell;
@property (nonatomic, retain) IBOutlet UIImageView *bannerView;

@property (nonatomic, retain) IBOutlet UITableViewCell *titleAndSeasonsAndEpisodesCell;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *seasonsAndEpisodesLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell *overviewCell;
@property (nonatomic, retain) IBOutlet UILabel *overviewLabel;

- (id)initWithShow:(Show *)theShow;


@end
