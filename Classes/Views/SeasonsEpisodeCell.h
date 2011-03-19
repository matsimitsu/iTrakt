#import <UIKit/UIKit.h>

@class Checkbox;

@interface SeasonsEpisodeCell : UITableViewCell {
  Checkbox *checkbox;
  UILabel *titleLabel;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate disclosureAccessory:(BOOL)flag;
- (void)setSelected:(BOOL)selected text:(NSString *)text;

@end
