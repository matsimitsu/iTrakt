#import "Episode.h"

@implementation Episode

@synthesize banner;
@synthesize title;
@synthesize season;
@synthesize number;

- (id)initWithTitle:(NSString *)title season:(NSUInteger)season number:(NSUInteger)number banner:(UIImage *)banner {
  if (self = [super init]) {
    self.title = title;
    self.season = season;
    self.number = number;
    self.banner = banner;
  }
  return self;
}

@end
