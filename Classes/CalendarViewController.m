#import "CalendarViewController.h"
#import "EpisodeTableViewCell.h"
#import "EpisodeDetailsViewController.h"

#import "Trakt.h"
#import "BroadcastDate.h"

#define ROW_HEIGHT 66.0

@implementation CalendarViewController

@synthesize broadcastDates;
@synthesize searchBar;
@synthesize filteredListContent;
@synthesize searchController;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = @"Calendar";
  self.tableView.rowHeight = ROW_HEIGHT;

  // TODO replace this with the actual username
  [Trakt sharedInstance].apiUser = @"matsimitsu";

  self.filteredListContent = [[NSMutableArray alloc] init];
  self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
  self.searchController.delegate = self;
  self.searchController.searchResultsDataSource = self;
  self.searchController.searchResultsDelegate = self;
  self.searchController.searchResultsTableView.rowHeight = ROW_HEIGHT;
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


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (tableView == self.tableView) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"E"];
    NSMutableArray *titles = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (BroadcastDate *broadcastDate in self.broadcastDates) {
      [titles addObject:[dateFormatter stringFromDate:broadcastDate.date]];
    }
    [dateFormatter release];
    return titles;
  } else {
    return nil;
  }
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  if (title == UITableViewIndexSearch) {
    [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
    return -1;
  } else {
    return index - 1;
  }
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == self.searchController.searchResultsTableView) {
    //NSLog(@"Sections in filtered set: %d", [filteredListContent count]);
    return [filteredListContent count];
  } else {
    return [broadcastDates count];
  }
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.searchController.searchResultsTableView) {
    NSMutableArray *dateWithEpisodes = [filteredListContent objectAtIndex:section];
    //NSLog(@"%d episodes on date: %@", [dateWithEpisodes count] - 1, ((BroadcastDate *)[dateWithEpisodes objectAtIndex:0]).date);
    return [dateWithEpisodes count] - 1;
  } else {
    BroadcastDate *broadcastDate = [broadcastDates objectAtIndex:section];
    return [broadcastDate.episodes count];
  }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  BroadcastDate *broadcastDate;
  if (tableView == self.searchController.searchResultsTableView) {
    broadcastDate = [(NSMutableArray *)[filteredListContent objectAtIndex:section] objectAtIndex:0];
    //NSLog(@"Section for %@", broadcastDate.date);
  } else {
    broadcastDate = [broadcastDates objectAtIndex:section];
  }
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

  if (tableView == self.searchController.searchResultsTableView) {
    NSArray *section = [filteredListContent objectAtIndex:indexPath.section];
    //NSLog(@"Episode show: %@", ((Episode *)[section objectAtIndex:(indexPath.row + 1)]).showTitle);
    cell.episode = [section objectAtIndex:(indexPath.row + 1)];
  } else {
    BroadcastDate *broadcastDate = [broadcastDates objectAtIndex:indexPath.section];
    cell.episode = [broadcastDate.episodes objectAtIndex:indexPath.row];
  }

  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Episode *episode;
  if (tableView == self.searchController.searchResultsTableView) {
    NSArray *section = [filteredListContent objectAtIndex:indexPath.section];
    episode = [section objectAtIndex:(indexPath.row + 1)];
  } else {
    BroadcastDate *broadcastDate = [broadcastDates objectAtIndex:indexPath.section];
    episode = [broadcastDate.episodes objectAtIndex:indexPath.row];
  }

  EpisodeDetailsViewController *controller = [[EpisodeDetailsViewController alloc] initWithEpisode:episode];
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchText {
  //NSLog(@"Search for: %@", searchText);
  [self.filteredListContent removeAllObjects];

  NSMutableArray *dateWithEpisodes = nil;

  for (BroadcastDate *broadcastDate in self.broadcastDates) {
    for (Episode *episode in broadcastDate.episodes) {
      NSRange range = [episode.showTitle rangeOfString:searchText
                                               options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch];
      if (range.location != NSNotFound) {
        //NSLog(@"Episode: %@", episode.showTitle);
        if (dateWithEpisodes == nil) {
          dateWithEpisodes = [NSMutableArray arrayWithObject:broadcastDate];
        }
        [dateWithEpisodes addObject:episode];
      }
    }
    if (dateWithEpisodes) {
      [self.filteredListContent addObject:dateWithEpisodes];
      dateWithEpisodes = nil;
    }
  }

  return YES;
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
  self.broadcastDates = nil;
  self.searchController = nil;
}


@end

