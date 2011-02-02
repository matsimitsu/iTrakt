#import "BroadcastDate.h"
#import "Episode.h"

@implementation BroadcastDate

@synthesize date;
@synthesize episodes;

- (id)initWithDictionary:(NSDictionary *)dict {
    if(self = [super init]) {

      int epoch_seconds = [[dict valueForKeyPath:@"date_epoch"] intValue];
      self.date = [NSDate dateWithTimeIntervalSince1970:epoch_seconds];

      NSMutableArray *objectifiedEpisodes = [[[NSMutableArray alloc] init] autorelease];

      for(id episode in [dict valueForKeyPath:@"episodes"]) {
        [objectifiedEpisodes addObject:[[Episode alloc] initWithDictionary:episode]];
      }

      self.episodes = objectifiedEpisodes;
    }

    return self;
}

@end
