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
    NSLog(@"Init with banner %@", [banner description]);
  }
  return self;
}

@end
