#import "LibraryViewController.h"
#import "Trakt.h"
#import "HTTPDownload.h"
#import "Show.h"

@implementation LibraryViewController


@synthesize shows, filteredShows, indexTitles;
@synthesize searchBar, searchController;


- (void)viewDidLoad {
  [super viewDidLoad];

  [self showRefreshDataButton];
  self.navigationItem.title = @"Library";

  self.filteredShows = [NSMutableArray new];
  self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
  self.searchController.delegate = self;
  self.searchController.searchResultsDataSource = self;
  self.searchController.searchResultsDelegate = self;
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  // TODO This should be done in one place (superclass)
  NSString *username = [Trakt sharedInstance].apiUser;
  self.navigationItem.rightBarButtonItem.title = username == nil ? @"Sign in" : username;

  if (self.shows == nil && [Trakt sharedInstance].library != nil) {
    NSLog(@"Loading library data from Trakt instance which has already loaded it");
    [self loadData:[Trakt sharedInstance].library];
  }
}


- (void)refreshData {
  NSLog(@"Refresh library data!");
  [self showStopRefreshDataButton];
  [[Trakt sharedInstance] retrieveTopLevelControllerdataStartingWith:@"library:" block:^(NSArray *loadedShows) {
    [self showRefreshDataButton];
    [self loadData:loadedShows];
  }];
}

// TODO This should be done in one place (superclass)
- (void)showRefreshDataButton {
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(refreshData)];
  self.navigationItem.leftBarButtonItem = refreshButton;
  [refreshButton release];
}
- (void)showStopRefreshDataButton {
  UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                              target:self
                                                                              action:@selector(cancelRefreshData)];
  self.navigationItem.leftBarButtonItem = stopButton;
  [stopButton release];
}


- (void)cancelRefreshData {
  [self showRefreshDataButton];
  [HTTPDownload cancelDownloadsInProgress];
}


- (void)loadData:(NSArray *)loadedShows {
  NSMutableArray *groupedShows = [NSMutableArray array];
  NSMutableArray *titles = [NSMutableArray array];

  NSRange skipPrefixRange = NSMakeRange(4, 1);
  for (Show *show in loadedShows) {
    NSString *letter;
    if ([show.title hasPrefix:@"The "]) {
      letter = [show.title substringWithRange:skipPrefixRange];
    } else {
      letter = [show.title substringToIndex:1];
    }
    if (![letter isEqualToString:[titles lastObject]]) {
      [titles addObject:letter];
      [groupedShows addObject:[NSMutableArray arrayWithObject:show]];
    } else {
      [[groupedShows lastObject] addObject:show];
    }
  }

  self.shows = groupedShows;
  self.indexTitles = titles;
  [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (tableView == self.tableView) {
    NSMutableArray *titles = [NSMutableArray arrayWithObjects:UITableViewIndexSearch, @"123", nil];
    char i;
    for (i = 'A'; i <= 'Z'; i++) {
      [titles addObject:[NSString stringWithFormat:@"%c", i]];
    }
    return titles;
  } else {
    return nil;
  }
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  if (title == UITableViewIndexSearch) {
    [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
    return -1;
  } else if ([title isEqualToString:@"123"]) {
    return 0;
  } else {
    char selected = [title UTF8String][0];
    NSInteger i = [self.indexTitles count] - 1;
    for (; i >= 0; i--) {
      NSString *t = [self.indexTitles objectAtIndex:i];
      char character = [t UTF8String][0];
      // don't further descrease `i' if `character' is a letter and is equal to
      // the selected letter or higher than the available letter in indexTitles
      if (character > 64 && selected >= character) {
        break;
      }
    }
    return i;
  }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == self.tableView) {
    return [self.shows count];
  } else {
    return 1;
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.tableView) {
    return [[self.shows objectAtIndex:section] count];
  } else {
    return [self.filteredShows count];
  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }

  Show *show;
  if (tableView == self.tableView) {
    show = [[self.shows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  } else {
    show = [self.filteredShows objectAtIndex:indexPath.row];
  }

  UILabel *label = cell.textLabel;
  label.text = show.title;
  return cell;
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Show *show;
  if (tableView == self.tableView) {
    show = [[self.shows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  } else {
    show = [self.filteredShows objectAtIndex:indexPath.row];
  }
  ShowDetailsViewController *controller = [[ShowDetailsViewController alloc] initWithShow:show];
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchText {
  [filteredShows removeAllObjects];
  for (NSArray *section in self.shows) {
    for (Show *show in section) {
      NSRange range = [show.title rangeOfString:searchText
                                        options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch];
      if (range.location != NSNotFound) {
        [filteredShows addObject:show];
      }
    }
  }
  return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
  self.shows = nil;
  self.filteredShows = nil;
  [super dealloc];
}

@end
