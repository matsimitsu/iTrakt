#import "BroadcastDate.h"
#import "Episode.h"

@implementation BroadcastDate

@synthesize date;
@synthesize episodes;

- (id)initWithDictionary:(NSDictionary *)dict {
    if(self = [super init]) {
      NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
      dateFormatter.dateFormat = @"yyyy-mm-dd";
      self.date = [dateFormatter dateFromString:[dict valueForKeyPath:@"date"]];

      NSMutableArray *objectifiedEpisodes = [[[NSMutableArray alloc] init] autorelease];

      for(id episode in [dict valueForKeyPath:@"episodes"]) {
        [objectifiedEpisodes addObject:[[Episode alloc] initWithDictionary:episode]];
      }

      self.episodes = objectifiedEpisodes;
    }

    return self;
}

@end
