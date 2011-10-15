#import "LibraryViewController.h"

#import "Show.h"
#import "ShowDetailsViewController.h"
#import "AuthenticationViewController.h"
#import "Trakt.h"
#import "HTTPDownload.h"

@implementation LibraryViewController

@synthesize library, filteredShows, indexTitles;
@synthesize searchBar, searchController;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self checkAuth];

  self.feedSelector = @"library:";
  self.cachedFeedProperty = @"library";

  self.navigationItem.title = @"Library";

  self.filteredShows = [NSMutableArray new];
  self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
  self.searchController.delegate = self;
  self.searchController.searchResultsDataSource = self;
  self.searchController.searchResultsDelegate = self;
}

- (void)reloadTableViewData:(NSArray *)data {

  NSMutableArray *groupedShows = [NSMutableArray array];
  NSMutableArray *titles = [NSMutableArray array];

  NSRange skipPrefixRange = NSMakeRange(4, 1);
  for (Show *show in data) {
    NSString *letter;
    if ([show.title hasPrefix:@"The "]) {
      letter = [show.title substringWithRange:skipPrefixRange];
    } else {
      letter = [show.title substringToIndex:1];
    }
    letter = [letter uppercaseString];

    if ([letter UTF8String][0] < 65) {
      // it's a number, which are at the start of the feed, so assume the array is at the beginning or should be
      NSMutableArray *group = [groupedShows lastObject];
      if (group == nil) {
        group = [NSMutableArray array];
        [groupedShows addObject:group];
      }
      [group addObject:show];
    } else {
      if (![letter isEqualToString:[titles lastObject]]) {
        [titles addObject:letter];
        [groupedShows addObject:[NSMutableArray arrayWithObject:show]];
      } else {
        [[groupedShows lastObject] addObject:show];
      }
    }
  }

  self.library = groupedShows;
  self.indexTitles = titles;

  [super reloadTableViewData:data];
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -
#pragma mark Table view data source


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (tableView == self.tableView) {
    NSMutableArray *titles = [NSMutableArray arrayWithObjects:UITableViewIndexSearch, @"#", nil];
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
  } else if ([title isEqualToString:@"#"]) {
    return 0;
  } else {
    char selected = [title UTF8String][0];
    NSInteger i = [self.indexTitles count] - 1;
    for (; i >= 0; i--) {
      char character = [(NSString *)[self.indexTitles objectAtIndex:i] UTF8String][0];
      // don't further descrease `i' if `character' is a letter and is equal to
      // the selected letter or higher than the available letter in indexTitles
      if (character >= 65 && selected >= character) {
        break;
      }
    }
    return i+1; // offset by one because of the '123' section title
  }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == self.tableView) {
    return [self.library count];
  } else {
    return 1;
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.tableView) {
    return [[self.library objectAtIndex:section] count];
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
    show = [[self.library objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
    show = [[self.library objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
  for (NSArray *section in self.library) {
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


- (void)dealloc {
  self.library = nil;
  self.filteredShows = nil;
  [super dealloc];
}

@end
