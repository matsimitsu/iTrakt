#import "CalendarViewController.h"
#import "BroadcastDate.h"
#import "EpisodeTableViewCell.h"
#import "EpisodeDetailsViewController.h"
#import "Trakt.h"

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

  // TODO this probably has to move to viewDidAppear so that it gets run whenever this view is shown, not just the first time!
  [[Trakt sharedInstance] calendar:^(NSArray *dates) {
    self.broadcastDates = dates;
    [self.tableView reloadData];
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

  [dateFormatter setDateFormat:@"EEEE MMMM d"];

  return [dateFormatter stringFromDate:broadcastDate.date];
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
  Episode *episode = [broadcastDate.episodes objectAtIndex:indexPath.row];
  
  [episode ensureShowPosterIsLoaded:^{
    // this callback is only run if the image has to be downloaded first
    NSLog(@"Show poster was downloaded for cell at: %@", indexPath);
    [[self.tableView cellForRowAtIndexPath:indexPath] setNeedsLayout];
  }];

  cell.episode = episode;

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


// TODO this is where we should deliver our own section headers
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  //return 50.0;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  //UIToolbar *bar = [UIToolbar new];
  //bar.barStyle = UIBarStyleBlack;
  //UIBarButtonItem *label = [UIBarButtonItem new];
  //label.style = UIBarButtonItemStylePlain;
  //label.enabled = NO;
  //label.title = @"FOO";
  //bar.items = [NSArray arrayWithObject:label];
  //return bar;
//}

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

