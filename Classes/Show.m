#import "Show.h"

@implementation Show

@synthesize tvdbID;
@synthesize title;
@synthesize year;

- (id)initWithDictionary:(NSDictionary *)showDict {
  if (self = [super init]) {
    self.tvdbID = [[showDict valueForKey:@"tvdb_id"] copy];
    self.title  = [[showDict valueForKey:@"title"] copy];
    self.year   = [[showDict valueForKey:@"year"] integerValue];
  }
  return self;
}

@end
