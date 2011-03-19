#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class CheckboxDrawing;

@interface Checkbox : UIControl {
  CheckboxDrawing *drawing;
}

- (void)setSelected:(BOOL)flag withAnimation:(BOOL)animate;

@end
