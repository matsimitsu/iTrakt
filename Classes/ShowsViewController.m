#import "ShowsViewController.h"
#import "ShowTableViewCell.h"
#import "ShowDetailsViewController.h"

#import "Trakt.h"
#import "Show.h"

#define ROW_HEIGHT 66.0

@implementation ShowsViewController

@synthesize shows;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.rowHeight = ROW_HEIGHT;
  // TODO replace this with the actual username
  [Trakt sharedInstance].apiUser = @"matsimitsu";
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

  ShowTableViewCell *cell = (ShowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[ShowTableViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
  }

  Show *show = [self.shows objectAtIndex:indexPath.row];

  [show ensurePosterIsLoaded:^{
    // this callback is only run if the image has to be downloaded first
    //NSLog(@"Show poster was downloaded for cell at: %@", indexPath);
    ShowTableViewCell *cellToReload = (ShowTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cellToReload.show = show;
    [cellToReload setNeedsLayout];
  }];

  cell.show = show;

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


