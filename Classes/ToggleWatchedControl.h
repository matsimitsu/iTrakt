
#import <UIKit/UIKit.h>

@class ToggleWatchedControl;

@protocol CheckBoxViewDelegate
- (void) checkBoxValueChanged:(ToggleWatchedControl *) cview;
@end

@interface ToggleWatchedControl : UIView {
    UILabel *checkMark;
    bool isOn;
    UIColor *color;
    NSObject<CheckBoxViewDelegate> *delegate;
}
@property(assign) bool isOn;
@property(assign) NSObject<CheckBoxViewDelegate> *delegate;

- (void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef) context;
@end
