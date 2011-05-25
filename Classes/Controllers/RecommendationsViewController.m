#import "RecommendationsViewController.h"

#import "Show.h"
#import "ShowTableViewCell.h"
#import "ShowDetailsViewController.h"

#import "Trakt.h"
#import "HTTPDownload.h"

@implementation RecommendationsViewController

@synthesize recommendations;

- (void)viewDidLoad {
  [super viewDidLoad];

  self.feedSelector = @"recommendations:";
  self.cachedFeedProperty = @"recommendations";

  self.navigationItem.title = @"Recommended";
}

- (void)reloadTableViewData:(NSArray *)data {
  self.recommendations = data;
  [super reloadTableViewData:data];
}

- (void)loadImageForCell:(UITableViewCell *)cell {
  ShowTableViewCell *showCell = (ShowTableViewCell *)cell;
  [showCell.show ensurePosterIsLoaded:^{
    // this callback is only run if the image has to be downloaded first
    [showCell setNeedsLayout];
  }];
}

#pragma mark -
#pragma mark Table view data source/delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.recommendations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";

  ShowTableViewCell *cell = (ShowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[ShowTableViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
  }

  cell.show = [self.recommendations objectAtIndex:indexPath.row];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Show *show = [self.recommendations objectAtIndex:indexPath.row];
  ShowDetailsViewController *controller = [[ShowDetailsViewController alloc] initWithShow:show];
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  [super dealloc];
  self.recommendations = nil;
}

@end
