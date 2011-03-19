#import <UIKit/UIKit.h>
#import "Checkbox.h"

@interface CheckboxCell : UITableViewCell {
  Checkbox *checkbox;
  UILabel *titleLabel;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate disclosureAccessory:(BOOL)flag;
- (void)setSelected:(BOOL)selected text:(NSString *)text;

@end
