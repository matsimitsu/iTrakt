//
//  ShowDetailsViewController.m
//  iTrakt
//
//  Created by Robert Beekman on 03-02-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowDetailsViewController.h"
#import "ImageCell.h"
#import "Episode.h"
#import "EpisodeDetailsViewController.h"

#define SHOW_IMAGE_ASPECT_RATIO 1.78

@implementation ShowDetailsViewController

@synthesize show;
@synthesize seasons;

- (id)initWithShow:(Show *)theShow {
  if (self = [super initWithNibName:@"ShowDetailsViewController" bundle:nil]) {
    self.show = theShow;
    self.navigationItem.title = show.title;
    [show ensureSeasonsAreLoaded:^{
      self.seasons = show.seasons;
      [self.tableView reloadData];
    }];
  }
  return self;
}

#pragma mark -
#pragma mark View lifecycle


/*
- (void)viewDidLoad {
    [super viewDidLoad];

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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (seasons == nil) {
      return 2;
    } else {
      return [self.seasons count] + 2;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
      return 1;
    } else if (section == 1) {
      return 1;
    } else {
      NSDictionary *seasonDict = [seasons objectAtIndex:section - 2];
      return [[seasonDict valueForKey:@"episode_count"] integerValue];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    CGFloat indentationWidth = 10.0;
    CGFloat width = self.tableView.bounds.size.width - (2 * indentationWidth);
    return floor(width / SHOW_IMAGE_ASPECT_RATIO);
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      // Calculate height for episode overview
      if (show.overview) {
        CGSize size = [show.overview sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
                                        constrainedToSize:CGSizeMake(300.0, 20000.0)
                                            lineBreakMode:UILineBreakModeWordWrap];
        return size.height + 48.0;
      }
    }
    // Other text cells have the default height
  }
  return self.tableView.rowHeight;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section >= 2) {
    NSDictionary *seasonDict = [seasons objectAtIndex:section - 2];
    NSInteger seasonNumber = [[seasonDict valueForKey:@"season"] integerValue];
    if (seasonNumber == 0) {
      return @"Specials";
    } else {
      return [NSString stringWithFormat:@"Season %d", seasonNumber, nil];
    }
   } else {
     return nil;
  }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    static NSString *cellIdentifier = @"showImageCell";
    ImageCell *cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[[ImageCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
    }

    [show ensureThumbIsLoaded:^{
      // this callback is only run if the image has to be downloaded first
      //NSLog(@"Episode thumb was downloaded for cell");
      ImageCell *cellToReload = (ImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
      cellToReload.image = show.thumb;
      [cellToReload setNeedsLayout];
    }];

    cell.image = show.thumb;
    return cell;
  } else if (indexPath.section == 1) {
    static NSString *cellIdentifier = @"textCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
      cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
      cell.textLabel.numberOfLines = 0;
      cell.textLabel.minimumFontSize = [UIFont systemFontSize];
      cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *label = cell.textLabel;
    switch (show.overview == nil ? (indexPath.row + 1) : indexPath.row) {
      case 0:
        label.text = show.overview;
        break;
    }
    return cell;
  } else {
    static NSString *cellIdentifier = @"episodeCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
      cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
      cell.textLabel.numberOfLines = 0;
      cell.textLabel.minimumFontSize = [UIFont systemFontSize];
      cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    UILabel *label = cell.textLabel;
    NSDictionary *seasonDict = [seasons objectAtIndex:indexPath.section - 2];
    NSArray *episodesArray = [seasonDict valueForKey:@"episodes"];
    NSDictionary *episodeDict = [episodesArray objectAtIndex:indexPath.row];
    label.text = [[episodeDict valueForKey:@"name"] copy];
    return cell;
  }
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
  if (indexPath.section >= 2) {
    NSDictionary *seasonDict = [seasons objectAtIndex:indexPath.section - 2];
    NSArray *episodesArray = [seasonDict valueForKey:@"episodes"];
    NSDictionary *episodeDict = [episodesArray objectAtIndex:indexPath.row];

    Episode *episode = [[Episode alloc] initWithDictionary:episodeDict show:show];
    EpisodeDetailsViewController *controller = [[EpisodeDetailsViewController alloc] initWithEpisode:episode];
    [episode release];

    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
  }
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
}


@end

