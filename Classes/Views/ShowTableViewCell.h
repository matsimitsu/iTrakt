#import <UIKit/UIKit.h>
#import "Show.h"

@interface ShowTableViewCell : UITableViewCell {
  Show *show;
  UIImageView *imageView;
  UILabel *titleLabel;
  UILabel *excerptLabel;
}

@property (nonatomic, retain) Show *show;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *excerptLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
