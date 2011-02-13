#import "CalendarViewController.h"
#import "EpisodeTableViewCell.h"
#import "EpisodeDetailsViewController.h"

#import "Trakt.h"
#import "BroadcastDate.h"

#define ROW_HEIGHT 66.0

@implementation CalendarViewController

@synthesize broadcastDates;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = @"Calendar";
  self.tableView.rowHeight = ROW_HEIGHT;

  // TODO replace this with the actual username
  [Trakt sharedInstance].apiUser = @"matsimitsu";
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  // TODO recache everyday!
  if (self.broadcastDates == nil) {
    [[Trakt sharedInstance] calendar:^(NSArray *dates) {
      self.broadcastDates = dates;
      [self reloadTableViewData];
    }];
  }
}


- (void)loadImageForCell:(UITableViewCell *)cell {
  EpisodeTableViewCell *episodeCell = (EpisodeTableViewCell *)cell;
  [episodeCell.episode ensureShowPosterIsLoaded:^{
    // this callback is only run if the image has to be downloaded first
    [episodeCell setNeedsLayout];
  }];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [broadcastDates count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  BroadcastDate *broadcastDate = [broadcastDates objectAtIndex:section];
  return [broadcastDate.episodes count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  BroadcastDate *broadcastDate = [broadcastDates objectAtIndex:section];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
  [dateFormatter setDateFormat:@"EEEE MMMM d"];

  NSString *result = [dateFormatter stringFromDate:broadcastDate.date];
  [dateFormatter release];
  return result;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"episodeCell";
  EpisodeTableViewCell *cell = (EpisodeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[[EpisodeTableViewCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
    cell.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, self.tableView.rowHeight);
  }

  BroadcastDate *broadcastDate = [broadcastDates objectAtIndex:indexPath.section];
  cell.episode = [broadcastDate.episodes objectAtIndex:indexPath.row];

  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  BroadcastDate *broadcastDate = [broadcastDates objectAtIndex:indexPath.section];
  Episode *episode = [broadcastDate.episodes objectAtIndex:indexPath.row];

  EpisodeDetailsViewController *controller = [[EpisodeDetailsViewController alloc] initWithEpisode:episode];
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

