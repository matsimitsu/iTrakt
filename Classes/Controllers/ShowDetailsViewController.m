//
//  ShowDetailsViewController.m
//  iTrakt
//
//  Created by Robert Beekman on 03-02-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowDetailsViewController.h"
#import "ImageCell.h"
#import "SeasonsViewController.h"

#import "HTTPDownload.h"

#define SHOW_IMAGE_ASPECT_RATIO 1.78

@implementation ShowDetailsViewController

@synthesize show;

@synthesize bannerCell, bannerView;
@synthesize titleAndSeasonsAndEpisodesCell, titleLabel, seasonsAndEpisodesLabel;
@synthesize overviewCell, overviewLabel;

- (id)initWithShow:(Show *)theShow {
  if (self = [super initWithNibName:@"ShowDetailsViewController" bundle:nil]) {
    self.show = theShow;
    self.navigationItem.title = show.title;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [show ensureThumbIsLoaded:^{
    // this callback is only run if the image has to be downloaded first
    self.bannerView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
      self.bannerView.image = show.thumb;
      self.bannerView.alpha = 1.0;
    }];
  }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [HTTPDownload cancelDownloadsInProgress];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0:
      return self.bannerCell.bounds.size.height;

    case 1:
      return self.titleAndSeasonsAndEpisodesCell.bounds.size.height;

    case 2:
      // Calculate height for episode overview
      if (show.overview) {
        CGSize size = [show.overview sizeWithFont:self.overviewLabel.font
                                constrainedToSize:CGSizeMake(self.overviewLabel.bounds.size.width, 20000.0)
                                    lineBreakMode:UILineBreakModeWordWrap];
        return size.height + 48.0;
      }
  }
  return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0:
      self.bannerView.image = show.thumb;
      return self.bannerCell;

    case 1:
      self.titleLabel.text = show.title;
      return self.titleAndSeasonsAndEpisodesCell;

    case 2:
      self.overviewLabel.text = show.overview;
      return self.overviewCell;
  }
  return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SeasonsViewController *controller = [[SeasonsViewController alloc] initWithShow:self.show];
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  self.bannerCell = nil;
  self.bannerView = nil;

  self.titleAndSeasonsAndEpisodesCell = nil;
  self.titleLabel = nil;
  self.seasonsAndEpisodesLabel = nil;

  self.overviewCell = nil;
  self.overviewLabel = nil;
}


- (void)dealloc {
    [super dealloc];
    [show release];
}


@end

