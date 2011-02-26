#import "Season.h"
#import "Episode.h"

@implementation Season

@synthesize episodes;

- (id)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    number = [[dict valueForKey:@"season"] integerValue];
    self.episodes = [NSMutableArray array];
    for (NSDictionary *episodeDict in [dict valueForKey:@"episodes"]) {
      Episode *e = [[Episode alloc] initWithDictionary:episodeDict];
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
