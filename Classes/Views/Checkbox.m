#import "Checkbox.h"

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

@interface CheckboxDrawing : CALayer {
  BOOL selected;
}

- (void)setSelected:(BOOL)flag withAnimation:(BOOL)animate;

@end

@implementation CheckboxDrawing

- (void)setSelected:(BOOL)flag withAnimation:(BOOL)animate {
  selected = flag;
  [self setNeedsDisplay];
  if (flag && animate) {
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];

    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = [NSNumber numberWithFloat:0.4];
    opacity.toValue = [NSNumber numberWithFloat:1.0];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.27;
    group.animations = [NSArray arrayWithObjects:scale, opacity, nil];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    [self addAnimation:group forKey:@"selected"];
  }
}

- (void)drawInContext:(CGContextRef)context {
  CGGradientRef myGradient;
  CGColorSpaceRef myColorspace;
  size_t num_locations = 2;
  CGFloat locations[2] = { 0.0, 1.0 };
  CGFloat components[8] = { 0.89, 0.89, 0.89, 1.0,  // Start color
                            0.83, 0.83, 0.83, 1.0 }; // End color
   
  myColorspace = CGColorSpaceCreateDeviceRGB();
  myGradient = CGGradientCreateWithColorComponents(myColorspace, components,
                            locations, num_locations);

  CGPoint myStartPoint, myEndPoint;
  myStartPoint.x = 0.0;
  myStartPoint.y = 0.0;
  myEndPoint.x = 0.0;
  myEndPoint.y = self.bounds.size.height;

  addRoundedRect(context, CGRectInset(self.bounds, 2, 2), 3);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, myGradient, myStartPoint, myEndPoint, 0);
  
  //CGContextSetRGBStrokeColor(context, 0.53, 0.53, 0.53, 1);
  CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 1);

  //// Draw border
  CGContextSetLineWidth(context, 1.5);
  addRoundedRect(context, CGRectInset(self.bounds, 2, 2), 3);
  CGContextStrokePath(context);

  if (selected) {
    // Clear border where the checkmark crosses it
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextMoveToPoint(   context, 16, 2);
    CGContextAddLineToPoint(context, 20, 1);
    CGContextAddLineToPoint(context, 20, 4);
    CGContextAddLineToPoint(context, 17, 7);
    CGContextAddLineToPoint(context, 16, 2);
    CGContextFillPath(context);

    // Draw checkmark
    CGContextRestoreGState(context);
    CGContextSetRGBFillColor(context, 0.25, 0.25, 0.25, 1);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(   context,  7,    8);   // top of left part
    CGContextAddLineToPoint(context, 10,   11);   // top of middle part
    CGContextAddLineToPoint(context, 19,    1);   // top of right part
    CGContextAddLineToPoint(context, 20,    2);   // bottom of right part
    //CGContextAddArcToPoint(context, 16, 6, 10.5, 16, 2); // arc from mid right part to bottom of middle part?
    //CGContextAddArcToPoint(context, 10.5, 10, 10.5, 16, 2); // arc from mid right part to bottom of middle part?
    CGContextAddLineToPoint(context, 16,    6);   // steeper path from mid right part to bottom of middle part
    CGContextAddLineToPoint(context, 10.5, 16);   // bottom of middle part
    CGContextAddLineToPoint(context,  5.5,  9.5); // bottom of left part
    CGContextAddLineToPoint(context,  7,    8);   // close path
    CGContextFillPath(context);
  }
}

@end

@implementation Checkbox

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    drawing = [CheckboxDrawing new];
    drawing.frame = CGRectMake(0, 0, 21, 21);
    [self.layer addSublayer:drawing];

    self.selected = NO;
  }
  return self;
}

- (void)setSelected:(BOOL)flag {
  [self setSelected:flag withAnimation:YES];
}

- (void)setSelected:(BOOL)flag withAnimation:(BOOL)animate {
  [super setSelected:flag];
  [drawing setSelected:flag withAnimation:animate];
}

- (void)dealloc {
  [drawing release];
  [super dealloc];
}


@end
