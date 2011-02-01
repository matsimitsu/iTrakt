#import <UIKit/UIKit.h>
#import "Show.h"

@interface ShowTableViewCell : UITableViewCell {
  Show *show;
  UIImageView *imageView;
  UILabel *titleLabel;
}

@property (nonatomic, retain) Show *show;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
