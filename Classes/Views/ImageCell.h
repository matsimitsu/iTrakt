#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell {
  UIImage *image;
  UIImageView *imageView;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
