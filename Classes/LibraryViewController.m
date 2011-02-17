#import "LibraryViewController.h"
#import "Trakt.h"
#import "Show.h"

@implementation LibraryViewController
@synthesize shows;


- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = @"Calendar";
 // self.tableView.rowHeight = ROW_HEIGHT;

  // TODO replace this with the actual username
  [Trakt sharedInstance].apiUser = @"matsimitsu";
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  // TODO recache everyday!
  if (self.shows == nil) {
    [[Trakt sharedInstance] library:^(NSArray *_shows) {
      self.shows = _shows;
      [self.tableView reloadData];
    }];
  }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.shows count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  Show *show = [self.shows objectAtIndex:indexPath.row];
  UILabel *label = cell.textLabel;
  label.text = show.title;
  return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Show *show = [self.shows objectAtIndex:indexPath.row];
  ShowDetailsViewController *controller = [[ShowDetailsViewController alloc] initWithShow:show];
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end