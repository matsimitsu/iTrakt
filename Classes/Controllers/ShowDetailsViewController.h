#import <UIKit/UIKit.h>
#import "Show.h"

@interface ShowDetailsViewController : UITableViewController {
  Show *show;
}

@property (nonatomic, retain) Show *show;

- (id)initWithShow:(Show *)theShow;


@end
