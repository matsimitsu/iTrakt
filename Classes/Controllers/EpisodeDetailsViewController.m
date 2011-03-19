#import "EpisodeDetailsViewController.h"
#import "ImageCell.h"
#import "SeasonsEpisodeCell.h"

#define EPISODE_IMAGE_ASPECT_RATIO 1.78

@implementation EpisodeDetailsViewController

@synthesize episode;

- (id)initWithEpisode:(Episode *)theEpisode {
  if (self = [super initWithNibName:@"EpisodeDetailsViewController" bundle:nil]) {
    self.episode = theEpisode;
    self.navigationItem.title = episode.show.title;
  }
  return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [super dealloc];
  [episode release];
}


#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  } else {
    return episode.overview == nil ? 2 : 3;
  }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return section == 0 ? self.episode.title : nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    // Calculate height for image cell
    // TODO: duplication of code in ImageCell
    CGFloat indentationWidth = 10.0;
    CGFloat width = self.tableView.bounds.size.width - (2 * indentationWidth);
    return floor(width / EPISODE_IMAGE_ASPECT_RATIO);
  } else {
    if (indexPath.row == 0) {
      // Calculate height for episode overview
      if (episode.overview) {
        CGSize size = [episode.overview sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
                                        constrainedToSize:CGSizeMake(300.0, 20000.0)
                                            lineBreakMode:UILineBreakModeWordWrap];
        return size.height + 48.0;
      }
    }
    // Other text cells have the default height
    return self.tableView.rowHeight;
  }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  if (indexPath.section == 0) {
    static NSString *imageCellIdentifier = @"episodeImageCell";
    cell = [tableView dequeueReusableCellWithIdentifier:imageCellIdentifier];
    if (cell == nil) {
      cell = [[[ImageCell alloc] initWithReuseIdentifier:imageCellIdentifier] autorelease];
    }
    [episode ensureThumbIsLoaded:^{
      // this callback is only run if the image has to be downloaded first
      //NSLog(@"Episode thumb was downloaded for cell");
      ImageCell *cellToReload = (ImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
      cellToReload.image = episode.thumb;
      [cellToReload setNeedsLayout];
    }];
    ((ImageCell *)cell).image = episode.thumb;

  } else {
    NSUInteger row = episode.overview == nil ? (indexPath.row + 1) : indexPath.row;

    if (row == 2) {
      static NSString *checkboxCellIdentifier = @"checkboxCell";
      cell = [tableView dequeueReusableCellWithIdentifier:checkboxCellIdentifier];
      if (cell == nil) {
        cell = [[[SeasonsEpisodeCell alloc] initWithReuseIdentifier:checkboxCellIdentifier delegate:self disclosureAccessory:NO] autorelease];
      }
      [(SeasonsEpisodeCell *)cell setSelected:episode.seen text:@"Seen"];

    } else {
      static NSString *textCellIdentifier = @"textCell";
      cell = [tableView dequeueReusableCellWithIdentifier:textCellIdentifier];
      if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIdentifier] autorelease];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.minimumFontSize = [UIFont systemFontSize];
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
      }

      if (row == 0) {
        cell.textLabel.text = episode.overview;
      } else {
        // row 1
        cell.textLabel.text = [NSString stringWithFormat:@"Episode %@", [episode episodeNumber], nil];
      }
    }
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}


@end
