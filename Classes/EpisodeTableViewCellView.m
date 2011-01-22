#import "EpisodeTableViewCellView.h"

@implementation EpisodeTableViewCellView

@synthesize episode;
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height - [UIFont smallSystemFontSize])];
    [self addSubview:imageView];
  }
  return self;
}

-(void)setEpisode:(Episode *)newEpisode {
  NSLog(@"SET EPISODE: %@", newEpisode.title);
  if (episode) {
    [episode release];
  }
  episode = newEpisode;
  [episode retain];
  self.imageView.image = episode.banner;
  //[self setNeedsDisplay];
}

//- (void)drawRect:(CGRect)rect {
  //NSLog(@"Draw image %@ in rect: %@", [self.episode.banner description], NSStringFromRect(rect));
  //[self.episode.banner drawAtPoint:rect.origin];
//}

- (void)dealloc {
  [super dealloc];
  [episode dealloc];
  [imageView dealloc];
}


@end
