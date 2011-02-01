#import "Show.h"
#import "Trakt.h"

@implementation Show

@synthesize tvdbID;
@synthesize title;
@synthesize poster;
@synthesize year;

- (id)initWithDictionary:(NSDictionary *)showDict {
  if (self = [super init]) {
    self.tvdbID = [[showDict valueForKey:@"tvdb_id"] copy];
    self.title  = [[showDict valueForKey:@"title"] copy];
    self.year   = [[showDict valueForKey:@"year"] integerValue];
  }
  return self;
}

// TODO this should come from the JSON and be stored in a property, but for now I'm hardcoding it.
- (NSURL *)posterURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://itrakt.matsimitsu.com/uploads/%@/poster-%@.jpg", self.tvdbID, self.tvdbID, nil]];
}

// TODO needs spec!
- (void)ensurePosterIsLoaded:(void (^)())downloadedBlock {
  // important to first check if we already have the poster loaded for performance!
  if (self.poster == nil) {
    [[Trakt sharedInstance] showPosterForURL:[self posterURL] block:^(UIImage *thePoster, BOOL cached) {
      self.poster = thePoster;
      if (!cached) {
        //NSLog(@"Downloaded show poster with tvdb ID: %@", tvdbID);
        downloadedBlock();
      }
      //else {
        //NSLog(@"Loaded show poster from cache with tvdb ID: %@", tvdbID);
      //}
    }];
  }
}

@end
