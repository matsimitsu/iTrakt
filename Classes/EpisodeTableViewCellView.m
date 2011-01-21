#import "EpisodeTableViewCellView.h"

@implementation EpisodeTableViewCellView

@synthesize episode;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  NSLog(@"DRAW!");
  [super drawRect:rect];
}


- (void)dealloc {
  [super dealloc];
  [episode dealloc];
}


@end
