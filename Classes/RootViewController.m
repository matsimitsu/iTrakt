#import "RootViewController.h"
#import "BroadcastDate.h"
#import "EpisodeTableViewCell.h"
#import "EpisodeDetailsViewController.h"
#import "CalendarRequest.h"

#define ROW_HEIGHT 66.0

@implementation RootViewController

@synthesize broadcastDates;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    [[CalendarRequest alloc] initWithDelegate:self];

    self.tableView.rowHeight = ROW_HEIGHT;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


- (void)datesLoaded:(NSArray *)dates {
  self.broadcastDates = dates;
  [self.tableView reloadData];
}


- (void)episodeDidLoadPoster:(Episode *)episode {
  NSUInteger indexes[2];
  BroadcastDate *broadcastDate = episode.broadcastDate;
  indexes[0] = [broadcastDates indexOfObject:broadcastDate];
  indexes[1] = [broadcastDate.episodes indexOfObject:episode];
  NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  if (cell && [[self.tableView visibleCells] indexOfObject:cell] != NSNotFound) {
    [cell setNeedsLayout];
  }
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
  cell.episode = episode;
  /*
    BroadcastDate *date = [broadcastDates objectAtIndex:indexPath.section];
    NSDictionary *episode = [date.episodes objectAtIndex:indexPath.row];
    cell.textLabel.text = [episode valueForKeyPath:@"show.title"];
  */

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

