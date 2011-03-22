#import "AuthenticationViewController.h"

@implementation AuthenticationViewController

@synthesize usernameField, passwordField;
@synthesize usernameCell, passwordCell;


- (void)dealloc {
  self.usernameField = nil;
  self.passwordField = nil;
  self.usernameCell = nil;
  self.passwordCell = nil;
  [super dealloc];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"user: %@ pass: %@", self.usernameCell, self.passwordCell);
  if (indexPath.row == 0) {
    return self.usernameCell;
  } else {
    return self.passwordCell;
  }
}


- (IBAction)dismissDialog:(id)sender {
  [self.parentViewController dismissModalViewControllerAnimated:YES];
}


@end

