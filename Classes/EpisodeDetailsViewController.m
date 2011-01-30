#import "EpisodeDetailsViewController.h"
#import "ImageCell.h"

#define EPISODE_IMAGE_ASPECT_RATIO 1.78

@implementation EpisodeDetailsViewController

@synthesize episode;

- (id)initWithEpisode:(Episode *)theEpisode {
  if (self = [super initWithNibName:@"EpisodeDetailsViewController" bundle:nil]) {
    self.episode = theEpisode;
    self.navigationItem.title = episode.showTitle;
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
  return section == 0 ? 1 : 3;
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
      // Calculate height for episode description
      CGSize size = [episode.description sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
                                      constrainedToSize:CGSizeMake(300.0, 20000.0)
                                          lineBreakMode:UILineBreakModeWordWrap];
      return size.height + 16.0;
    } else {
      // Other text cells have the default height
      return self.tableView.rowHeight;
    }
  }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    static NSString *cellIdentifier = @"episodeImageCell";
    ImageCell *cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[[ImageCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
    }

    [episode ensureThumbIsLoaded:^{
      // this callback is only run if the image has to be downloaded first
      NSLog(@"Episode thumb was downloaded for cell at: %@", indexPath);
      [[self.tableView cellForRowAtIndexPath:indexPath] setNeedsLayout];
    }];

    cell.image = episode.thumb;
    return cell;
  } else {
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
    switch (indexPath.row) {
      case 0:
        label.text = episode.description;
        break;
      case 1:
        label.text = [NSString stringWithFormat:@"Episode %@", [episode episodeNumber], nil];
        break;
      case 2:
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        label.text = @"Seen";
        break;
    }
    return cell;
  }
}


#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // this is the 'seen' row, the other section only has one row (the image)
  if (indexPath.row == 2) {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryNone ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [cell setSelected:NO animated:YES];
  }
}

@end
