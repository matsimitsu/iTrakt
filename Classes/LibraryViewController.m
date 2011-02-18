#import "LibraryViewController.h"
#import "Trakt.h"
#import "Show.h"

@implementation LibraryViewController


@synthesize shows, filteredShows, indexTitles;
@synthesize searchBar, searchController;


- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"Library";

  // TODO replace this with the actual username
  [Trakt sharedInstance].apiUser = @"matsimitsu";

  self.filteredShows = [NSMutableArray new];
  self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
  self.searchController.delegate = self;
  self.searchController.searchResultsDataSource = self;
  self.searchController.searchResultsDelegate = self;
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (self.shows == nil) {
    [[Trakt sharedInstance] library:^(NSArray *loadedShows) {
      self.shows = [NSMutableArray new];
      self.indexTitles = [NSMutableArray arrayWithObject:UITableViewIndexSearch];

      NSRange skipPrefixRange = NSMakeRange(4, 1);
      for (Show *show in loadedShows) {
        NSString *letter;
        if ([show.title hasPrefix:@"The "]) {
          letter = [show.title substringWithRange:skipPrefixRange];
        } else {
          letter = [show.title substringToIndex:1];
        }
        if (![letter isEqualToString:[indexTitles lastObject]]) {
          [indexTitles addObject:letter];
          [shows addObject:[NSMutableArray arrayWithObject:show]];
        } else {
          [[shows lastObject] addObject:show];
        }
      }

      [self.tableView reloadData];
    }];
  }
}


#pragma mark -
#pragma mark Table view data source


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (tableView == self.tableView) {
    return self.indexTitles;
  } else {
    return nil;
  }
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  if (title == UITableViewIndexSearch) {
    [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
    return -1;
  } else {
    return [self.indexTitles indexOfObject:title] - 1;
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
