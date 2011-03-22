#import <UIKit/UIKit.h>


@interface AuthenticationViewController : UIViewController {
  IBOutlet UITextField *usernameField;
  IBOutlet UITextField *passwordField;
  IBOutlet UITableViewCell *usernameCell;
  IBOutlet UITableViewCell *passwordCell;
  IBOutlet UIBarButtonItem *doneButton;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITableViewCell *usernameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *passwordCell;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)dismissDialog:(id)sender;
- (IBAction)saveCredentials:(id)sender;
- (IBAction)textDidChange:(id)sender;

@end
