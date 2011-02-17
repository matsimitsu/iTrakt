#import "LibraryViewController.h"
#import "Trakt.h"
#import "Show.h"
@implementation LibraryViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"Library";

  // TODO this probably has to move to viewDidAppear so that it gets run whenever this view is shown, not just the first time!
  [[Trakt sharedInstance] library:^(NSArray *_shows) {
    self.shows = _shows;
    [self reloadTableViewData];
  }];
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

@end