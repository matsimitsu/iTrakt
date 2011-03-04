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

@implementation CheckboxDrawing

@synthesize selected;

- (void)setSelected:(BOOL)flag {
  selected = flag;
  [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)context {
  NSLog(@"DRAW!");

  //CGContextSetRGBStrokeColor(context, 0.53, 0.53, 0.53, 1);
  CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 1);

  // Draw border
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
    //NSLog(@"Complete frame %@", NSStringFromCGRect(frame));
    CALayer *layer = self.layer;
    
    CAGradientLayer *boxBackground = [CAGradientLayer layer];
    UIColor *startColor  = [UIColor colorWithWhite:0.89 alpha:1.0];
    UIColor *endColor    = [UIColor colorWithWhite:0.83 alpha:1.0];
    boxBackground.colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    //boxBackground.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil];
    boxBackground.cornerRadius = 3.0;
    boxBackground.frame = CGRectMake(2, 2, 17, 17);
    [layer addSublayer:boxBackground];

    drawing = [CheckboxDrawing new];
    drawing.frame = CGRectMake(0, 0, 21, 21);
    [layer addSublayer:drawing];

    self.selected = NO;

    [self addTarget:self action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)setSelected:(BOOL)flag {
  NSLog(@"Set selection: %d", (int)flag);
  [super setSelected:flag];
  drawing.selected = flag;
}

- (void)checkboxClicked:(id)sender {
  NSLog(@"CLICKED!");
  self.selected = !self.selected;
}

- (void)dealloc {
  [drawing release];
  [super dealloc];
}


@end
