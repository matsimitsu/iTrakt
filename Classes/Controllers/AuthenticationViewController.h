#import <UIKit/UIKit.h>

@class AuthenticationViewController;

@protocol AuthenticationViewControllerDelegate
- (void)authenticationViewWillDismiss:(AuthenticationViewController *)controller;
@end

@interface AuthenticationViewController : UIViewController {
  BOOL signingIn, signedIn;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UILabel *signedInAsLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *usernameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *passwordCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *signingInCell, *signedInCell;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIButton *helpBannerButton;

@property (nonatomic, assign) id <AuthenticationViewControllerDelegate> delegate;

+ (BOOL)signIn;
+ (NSString *)signedInAs;
+ (void)retrieveUsername:(NSString **)username password:(NSString **)password;
+ (void)saveAndAuthenticate:(NSString *)username password:(NSString *)password;
+ (void)authenticate:(NSString *)username password:(NSString *)password;

- (IBAction)dismissDialog:(id)sender;
- (IBAction)saveCredentials:(id)sender;
- (IBAction)textDidChange:(id)sender;
- (IBAction)openTraktSite:(id)sender;

@end
