#import "AuthenticationViewController.h"
#import "Trakt.h"
#import "SSKeychain.h"

@implementation AuthenticationViewController


+ (BOOL)signIn {
  NSString *username, *password;
  [self retrieveUsername:&username password:&password];
  if (username && password) {
    NSLog(@"User: %@ Password: %@", username, password);
    [self authenticate:username password:password];
    return YES;
  }
  return NO;
}

+ (void)retrieveUsername:(NSString **)username password:(NSString **)password {
  *password = nil;
  *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
  if (*username) {
    *password = [SSKeychain passwordForService:@"iTrakt" account:*username];
  }
}

+ (void)authenticate:(NSString *)username password:(NSString *)password {
  [[Trakt sharedInstance] setApiUser:username];
  [[Trakt sharedInstance] setApiPassword:password];
}


@synthesize usernameField, passwordField;
@synthesize usernameCell, passwordCell;
@synthesize doneButton;


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  NSString *username, *password;
  [AuthenticationViewController retrieveUsername:&username password:&password];
  self.usernameField.text = username;
  self.passwordField.text = password;
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
  NSString *username = self.usernameField.text;
  NSString *password = self.passwordField.text;

  [AuthenticationViewController authenticate:username password:password];

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setValue:username forKey:@"Username"]; // TODO move to constant
  [defaults synchronize];
  [SSKeychain setPassword:password forService:@"iTrakt" account:username];

  [self dismissDialog:sender];
}


@end

