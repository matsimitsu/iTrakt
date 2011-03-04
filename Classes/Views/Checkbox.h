#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CheckboxDrawing : CALayer {
  BOOL selected;
}

@property (nonatomic, assign) BOOL selected;

@end


@interface Checkbox : UIControl {
  CheckboxDrawing *drawing;
}

@end
