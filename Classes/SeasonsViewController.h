#import <UIKit/UIKit.h>
#import "Show.h"


@interface SeasonsViewController : UITableViewController {
  Show *show;
  NSArray *seasons;
}

@property (nonatomic, retain) Show *show;
@property (nonatomic, retain) NSArray *seasons;

- (id)initWithShow:(Show *)theShow;

@end
