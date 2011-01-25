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
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return self.episode.title;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    // TODO: duplication of code in ImageCell
    CGFloat indentationWidth = 10.0;
    CGFloat width = self.tableView.bounds.size.width - ((2 * indentationWidth) + 0.75);
    return floor(width / EPISODE_IMAGE_ASPECT_RATIO);
  } else {
    return self.tableView.rowHeight;
  }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"episodeImageCell";
  ImageCell *cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[[ImageCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
  }

  cell.image = [UIImage imageNamed:@"episode.jpg"];

  return cell;
}

@end
