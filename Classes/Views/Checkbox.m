#import "Checkbox.h"
#import <QuartzCore/QuartzCore.h>

@interface CheckboxDrawing : CALayer

@end

static void
addRoundedRect(CGContextRef ctx, CGRect rect, float cornerRadius) {
  float x_left = rect.origin.x;
  float x_left_center = x_left + cornerRadius;
  float x_right_center = x_left + rect.size.width - cornerRadius;
  float x_right = x_left + rect.size.width;
  float y_top = rect.origin.y;
  float y_top_center = y_top + cornerRadius;
  float y_bottom_center = y_top + rect.size.height - cornerRadius;
  float y_bottom = y_top + rect.size.height;
  /* Begin path */
  CGContextBeginPath(ctx);
  CGContextMoveToPoint(ctx, x_left, y_top_center);
  /* First corner */
  CGContextAddArcToPoint(ctx, x_left, y_top, x_left_center, y_top, cornerRadius);
  /* Second corner */
  CGContextAddArcToPoint(ctx, x_right, y_top, x_right, y_top_center, cornerRadius);
  /* Third corner */
  CGContextAddArcToPoint(ctx, x_right, y_bottom, x_right_center, y_bottom, cornerRadius);
  /* Fourth corner */
  CGContextAddArcToPoint(ctx, x_left, y_bottom, x_left, y_bottom_center, cornerRadius);
  /* Done */
  CGContextClosePath(ctx);
}

@implementation CheckboxDrawing

- (void)drawInContext:(CGContextRef)context {
  CGContextSetRGBStrokeColor(context, 0.53, 0.53, 0.53, 1);
  CGContextSetLineWidth(context, 2);
  addRoundedRect(context, CGRectInset(self.bounds, 0.5, 0.5), 6);
  CGContextStrokePath(context);
}

@end

@implementation Checkbox

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    CALayer *layer = self.layer;
    
    CAGradientLayer *boxBackground = [CAGradientLayer layer];
    UIColor *startColor  = [UIColor colorWithWhite:0.89 alpha:1.0];
    UIColor *endColor    = [UIColor colorWithWhite:0.83 alpha:1.0];
    boxBackground.colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    //boxBackground.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil];
    boxBackground.cornerRadius = 4.0;
    //boxBackground.frame = CGRectMake(2, 2, frame.size.width - 2, frame.size.height - 2);
    boxBackground.frame = CGRectMake(2, 2, 26, 26);
    NSLog(@"BG frame: %@", NSStringFromCGRect(boxBackground.frame));
    [layer addSublayer:boxBackground];

    CALayer *drawing = [CheckboxDrawing layer];
    //drawing.frame = CGRectMake(2, 2, frame.size.width - 2, frame.size.height - 2);
    drawing.frame = CGRectMake(2, 2, 26, 26);
    [layer addSublayer:drawing];
    [drawing setNeedsDisplay];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

//- (void)dealloc {
  //[super dealloc];
//}


@end
