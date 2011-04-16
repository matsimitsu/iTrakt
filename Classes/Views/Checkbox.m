#import "Checkbox.h"
#import <QuartzCore/QuartzCore.h>

#define ANIMATION_DURATION 0.25

@implementation Checkbox

// TODO make one init method!

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.contentsGravity = kCAGravityCenter;
    [self setSelected:NO withAnimation:NO];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  if (self = [super initWithCoder:coder]) {
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.contentsGravity = kCAGravityCenter;
    [self setSelected:NO withAnimation:NO];
  }
  return self;
}

- (void)setSelected:(BOOL)flag {
  if (flag != self.selected) {
    [self setSelected:flag withAnimation:YES];
  }
}

- (void)setSelected:(BOOL)flag withAnimation:(BOOL)animate {
  [super setSelected:flag];

  NSString *name = flag ? @"checkbox-checked" : @"checkbox-unchecked";
  id image = (id)[UIImage imageNamed:name].CGImage;

  if (animate) {
    if (flag) {
      CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
      scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)];
      scale.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];

      CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
      opacity.fromValue = [NSNumber numberWithFloat:0.4];
      opacity.toValue = [NSNumber numberWithFloat:1.0];

      CAAnimationGroup *group = [CAAnimationGroup animation];
      group.duration = ANIMATION_DURATION;
      group.animations = [NSArray arrayWithObjects:scale, opacity, nil];
      group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

      self.layer.contents = image;
      [self.layer addAnimation:group forKey:@"selected"];

    } else {
      CABasicAnimation *xfade = [CABasicAnimation animationWithKeyPath:@"contents"];
      xfade.delegate = self;
      xfade.duration = ANIMATION_DURATION;
      xfade.toValue = image;
      [self.layer addAnimation:xfade forKey:nil];
    }

  } else {
    // no animation, just set the content
    self.layer.contents = image;
  }
}

- (void)animationDidStop:(CABasicAnimation *)animation finished:(BOOL)flag {
  self.layer.contents = animation.toValue;
}

@end
