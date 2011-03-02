#import "SeasonsViewController.h"
#import "Season.h"
#import "Episode.h"
#import "EpisodeDetailsViewController.h"
#import "HTTPDownload.h"
#import "ToggleWatchedControl.h"

@implementation SeasonsViewController

@synthesize show;
@synthesize seasons;


#pragma mark -
#pragma mark View lifecycle

- (id)initWithShow:(Show *)theShow {
  if (self = [super initWithNibName:@"SeasonsViewController" bundle:nil]) {
    self.show = theShow;
    self.navigationItem.title = @"Episodes";
  }
  return self;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (show.seasons == nil) {
    [show ensureSeasonsAreLoaded:^{
      self.seasons = show.seasons;
      [self.tableView reloadData];
    }];
  } else {
    self.seasons = show.seasons;
    [self.tableView reloadData];
  }
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return (seasons == nil) ? 0 : [seasons count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (seasons == nil) {
    return 0;
  } else {
    Season *season = [seasons objectAtIndex:section];
    return [season.episodes count];
  }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (seasons == nil) {
    return nil;
  } else {
    Season *season = [seasons objectAtIndex:section];
    return [season label];
  }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *cellIdentifier = @"episodeCell";
  UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.minimumFontSize = [UIFont systemFontSize];
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
  }

  CGRect CheckBoxFrame = CGRectMake(5,10,20,20);

  ToggleWatchedControl *toggleControl = [[ToggleWatchedControl alloc] initWithFrame: CheckBoxFrame];
  toggleControl.tag = indexPath.row;  // for reference in notifications.
  [cell.contentView addSubview: toggleControl];

  if (seasons != nil) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  CGSize size = cell.bounds.size;
  CGFloat labelWidth;
  labelWidth = size.width - 30;

  UILabel *label = cell.textLabel;
  label.frame = CGRectMake(0, 35, labelWidth, 30);

  NSDictionary *seasonDict = [seasons objectAtIndex:indexPath.section];
  NSArray *episodesArray = [seasonDict valueForKey:@"episodes"];
  NSDictionary *episodeDict = [episodesArray objectAtIndex:indexPath.row];
  toggleControl.isOn = [[episodeDict valueForKey:@"watched"] boolValue];

  label.text = [NSString stringWithFormat:@"%02d - %@", [[episodeDict valueForKey:@"episode"] integerValue], [episodeDict valueForKey:@"name"], nil];

  return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Season *season = [seasons objectAtIndex:indexPath.section];
  Episode *episode = [season.episodes objectAtIndex:indexPath.row];
  EpisodeDetailsViewController *controller = [[EpisodeDetailsViewController alloc] initWithEpisode:episode];
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
  [show release];
  [seasons release];
}


@end

