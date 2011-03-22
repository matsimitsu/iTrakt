#import <UIKit/UIKit.h>


@interface AuthenticationViewController : UIViewController {
  IBOutlet UITextField *usernameField;
  IBOutlet UITextField *passwordField;
  IBOutlet UITableViewCell *usernameCell;
  IBOutlet UITableViewCell *passwordCell;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITableViewCell *usernameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *passwordCell;

- (IBAction)dismissDialog:(id)sender;

@end
