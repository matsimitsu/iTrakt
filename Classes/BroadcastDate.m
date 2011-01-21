#import "BroadcastDate.h"

@implementation BroadcastDate

@synthesize date;
@synthesize episodes;

- (id)initWithDate:(NSDate *)date episodes:(NSArray *)episodes {
  if (self = [super init]) {
    self.date = date;
    self.episodes = episodes;
  }
  return self;
}

@end
