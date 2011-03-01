#import "BroadcastDate.h"
#import "Episode.h"

@implementation BroadcastDate

@synthesize date;
@synthesize episodes;

- (id)initWithDictionary:(NSDictionary *)dict {
    if(self = [super init]) {

      int epoch_seconds = [[dict valueForKeyPath:@"date_epoch"] intValue];
      self.date = [NSDate dateWithTimeIntervalSince1970:epoch_seconds];

      NSMutableArray *objectifiedEpisodes = [[NSMutableArray alloc] init];

      for(id episode in [dict valueForKeyPath:@"episodes"]) {
        Episode *e = [[Episode alloc] initWithDictionary:episode];
        [objectifiedEpisodes addObject:e];
        [e release];
      }

      NSSortDescriptor *airtimeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"show.airtime"
                                                                         ascending:YES
                                                                          selector:@selector(compare:)] autorelease];
      NSSortDescriptor *showTitleDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"show.title"
                                                                           ascending:YES
                                                                            selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
 
      NSArray *descriptors = [NSArray arrayWithObjects:airtimeDescriptor, showTitleDescriptor, nil];
      self.episodes = [objectifiedEpisodes sortedArrayUsingDescriptors:descriptors];
      [objectifiedEpisodes release];
    }

    return self;
}

@end
