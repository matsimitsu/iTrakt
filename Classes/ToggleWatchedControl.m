#import "ToggleWatchedControl.h"

#define SIZE 20.0
#define STROKE_WIDTH 1.2
#define ALPHA .6
#define RADIUS 2.0

@implementation ToggleWatchedControl
@synthesize isOn, delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, SIZE, SIZE)])) {
        // Initialization code
    }
    //UIColor *color = [UIColor blackColor];
    color = [[UIColor alloc] initWithWhite:.0 alpha:ALPHA];

    self.backgroundColor = [UIColor clearColor];
    checkMark = [[UILabel alloc] initWithFrame:CGRectMake(STROKE_WIDTH, STROKE_WIDTH, SIZE - 2 * STROKE_WIDTH, SIZE - 2*STROKE_WIDTH)];
    checkMark.font = [UIFont systemFontOfSize:15.];
    checkMark.text = @"\u2713";
    checkMark.backgroundColor = [UIColor clearColor];
    checkMark.textAlignment = UITextAlignmentCenter;
    //checkMark.textColor = [UIColor redColor];
    [self addSubview:checkMark];
    [checkMark setHidden:TRUE];
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect _rect = CGRectMake(STROKE_WIDTH, STROKE_WIDTH, SIZE - 2 * STROKE_WIDTH, SIZE - 2*STROKE_WIDTH);
    [self drawRoundedRect:_rect inContext:UIGraphicsGetCurrentContext()];
    [checkMark setHidden:!isOn];
}


- (void)dealloc {
    [checkMark release];
    [color release];
    [super dealloc];
}

- (void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef) context{
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, STROKE_WIDTH);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + RADIUS, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - RADIUS, CGRectGetMinY(rect) + RADIUS, RADIUS, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - RADIUS, CGRectGetMaxY(rect) - RADIUS, RADIUS, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + RADIUS, CGRectGetMaxY(rect) - RADIUS, RADIUS, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + RADIUS, CGRectGetMinY(rect) + RADIUS, RADIUS, M_PI, 3 * M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

#pragma mark Touch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self];
    if(CGRectContainsPoint(self.bounds, loc)){
        isOn = !isOn;
        //[self setNeedsDisplay];
        [checkMark setHidden:!isOn];
        if([delegate respondsToSelector:@selector(checkBoxValueChanged:)]){
            [delegate checkBoxValueChanged:self];
            return;
        }
    }
}

@end
