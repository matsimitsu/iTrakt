#import "CalendarViewController.h"

#import "Episode.h"
#import "EpisodeTableViewCell.h"
#import "EpisodeDetailsViewController.h"

#import "Trakt.h"
#import "HTTPDownload.h"
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

  self.feedSelector = @"calendar:";
  self.cachedFeedProperty = @"broadcastDates";

  self.navigationItem.title = @"Calendar";
  self.tableView.rowHeight = ROW_HEIGHT;

  self.filteredListContent = [[NSMutableArray alloc] init];
  self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
  self.searchController.delegate = self;
  self.searchController.searchResultsDataSource = self;
  self.searchController.searchResultsDelegate = self;
  self.searchController.searchResultsTableView.rowHeight = ROW_HEIGHT;
}

- (void)reloadTableViewData:(NSArray *)data {
  self.broadcastDates = data;
  [super reloadTableViewData:data];
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)loadImageForCell:(UITableViewCell *)cell {
  EpisodeTableViewCell *episodeCell = (EpisodeTableViewCell *)cell;
  [episodeCell.episode.show ensurePosterIsLoaded:^{
    // this callback is only run if the image has to be downloaded first
    [episodeCell setNeedsLayout];
  }];
}


#pragma mark -
#pragma mark Table view data source


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == self.searchController.searchResultsTableView) {
    return [filteredListContent count];
  } else {
    return [broadcastDates count];
  }
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.searchController.searchResultsTableView) {
    NSMutableArray *dateWithEpisodes = [filteredListContent objectAtIndex:section];
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
  [self.filteredListContent removeAllObjects];

  NSMutableArray *dateWithEpisodes = nil;

  for (BroadcastDate *broadcastDate in self.broadcastDates) {
    for (Episode *episode in broadcastDate.episodes) {
      NSRange range = [episode.show.title rangeOfString:searchText
                                                options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch];
      if (range.location != NSNotFound) {
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

- (void)dealloc {
  [super dealloc];
  self.broadcastDates = nil;
  self.searchController = nil;
}


@end

