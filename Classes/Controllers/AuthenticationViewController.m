#import "AuthenticationViewController.h"
#import "Trakt.h"
//#import "SSKeychain.h"

@implementation AuthenticationViewController

@synthesize usernameField, passwordField;
@synthesize usernameCell, passwordCell;
@synthesize doneButton;


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSLog(@"Hier!");
  self.usernameField.text = [[Trakt sharedInstance] apiUser];
}


- (void)dealloc {
  self.usernameField = nil;
  self.passwordField = nil;
  self.usernameCell = nil;
  self.passwordCell = nil;
  self.doneButton = nil;
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
  if (indexPath.row == 0) {
    return self.usernameCell;
  } else {
    return self.passwordCell;
  }
}


- (IBAction)textDidChange:(id)sender {
  self.doneButton.enabled = self.usernameField.text.length > 0 && self.passwordField.text.length > 0;
}


- (IBAction)dismissDialog:(id)sender {
  [self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (IBAction)saveCredentials:(id)sender {
  NSLog(@"Save!");
  [[Trakt sharedInstance] setApiUser:self.usernameField.text];
  [[Trakt sharedInstance] setApiPassword:self.passwordField.text];

  // TODO check if the credentials are correct somehow!
  // Where do we store the account? prefs??
  //[SSKeychain setPassword:self.passwordField.text forService:@"iTrakt" account:self.usernameField.text];

  [self dismissDialog:sender];
}


@end

