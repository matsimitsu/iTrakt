#import "EpisodeDetailsViewController.h"
#import "ImageCell.h"
#import "Checkbox.h"
#import "CheckboxCell.h"
#import "ShowDetailsViewController.h"

#import <QuartzCore/QuartzCore.h>

#define EPISODE_IMAGE_ASPECT_RATIO 1.78

@implementation EpisodeDetailsViewController

@synthesize episode;

@synthesize bannerCell, bannerView;
@synthesize titleAndEpisodeAndSeasonCell, seenCheckbox, titleLabel, episodeAndSeasonLabel;
@synthesize overviewCell, overviewLabel;
@synthesize showDetailsCell, showTitleLabel;

- (id)initWithEpisode:(Episode *)theEpisode {
  if (self = [super initWithNibName:@"EpisodeDetailsViewController" bundle:nil]) {
    self.episode = theEpisode;
    self.navigationItem.title = episode.show.title;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.seenCheckbox addTarget:self action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
  [episode ensureThumbIsLoaded:^{
    // this callback is only run if the image has to be downloaded first
    CABasicAnimation *xfade = [CABasicAnimation animationWithKeyPath:@"contents"];
    xfade.delegate = self;
    xfade.duration = 0.8;
    xfade.toValue = (id)episode.thumb.CGImage;
    [self.bannerView.layer addAnimation:xfade forKey:nil];
  }];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
  self.bannerView.image = episode.thumb;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
  [super dealloc];
  [episode release];
}


#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return episode.overview == nil ? 3 : 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0:
      return self.bannerCell.bounds.size.height;

    case 1:
      return self.titleAndEpisodeAndSeasonCell.bounds.size.height;

    case 2:
      // Calculate height for episode overview
      if (episode.overview) {
        CGSize size = [episode.overview sizeWithFont:self.overviewLabel.font
                                   constrainedToSize:CGSizeMake(self.overviewLabel.bounds.size.width, 20000.0)
                                       lineBreakMode:UILineBreakModeWordWrap];
        return size.height + 12.0;
      }
      break;

    case 3:
      return self.showDetailsCell.bounds.size.height;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0:
      self.bannerView.image = episode.thumb;
      return self.bannerCell;

    case 1:
      [self.seenCheckbox setSelected:episode.seen withAnimation:NO];
      self.titleLabel.text = episode.title;
      self.episodeAndSeasonLabel.text = [episode episodeAndSeason];
      return self.titleAndEpisodeAndSeasonCell;

    case 2:
      self.overviewLabel.text = episode.overview;
      return self.overviewCell;

    case 3:
      self.showTitleLabel.text = episode.show.title;
      return self.showDetailsCell;
  }
  return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 2 && episode.overview != nil) {
    cell.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 3) {
    ShowDetailsViewController *controller = [[ShowDetailsViewController alloc] initWithShow:episode.show];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
  }
}

- (void)checkboxClicked:(Checkbox *)checkbox {
  checkbox.selected = !episode.seen;
  [episode toggleSeen:^{
    checkbox.selected = episode.seen;
  }];
}


@end
