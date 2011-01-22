#import "Episode.h"

@implementation Episode

@synthesize banner;
@synthesize title;
@synthesize season;
@synthesize number;

- (id)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    self.title = [dict valueForKeyPath:@"episode.title"];
    self.season = (int) [dict valueForKeyPath:@"episode.season"];
    self.number = (int) [dict valueForKeyPath:@"episode.number"];
    NSLog([dict valueForKeyPath:@"show.banner"]);

    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict valueForKeyPath:@"show.banner"]]];
    self.banner = [UIImage imageWithData:imageData];
  }
  return self;
}

- (NSString *)numberText {
  return [NSString stringWithFormat:@"%dx%02d", season, number, nil];
}

@end
