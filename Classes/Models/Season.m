#import "Season.h"
#import "Episode.h"

@implementation Season

@synthesize episodes;

- (id)initWithShow:(Show *)show seasonInfo:(NSDictionary *)dict {
  if (self = [super init]) {
    number = [[dict valueForKey:@"season"] integerValue];
    self.episodes = [NSMutableArray array];
    for (NSDictionary *episodeDict in [dict valueForKey:@"episodes"]) {
      Episode *e = [[Episode alloc] initWithShow:show episodeInfo:episodeDict];
      [episodes addObject:e];
      [e release];
    }
  }
  return self;
}


- (void)dealloc {
  [super dealloc];
  [episodes release];
}


- (NSString *)label {
  if (number == 0) {
    return @"Specials";
  } else {
    return [NSString stringWithFormat:@"Season %d", number];
  }
}

@end
