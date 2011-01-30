#import "Episode.h"
#import "EGOCache.h"
#import <YAJL/YAJL.h>

#import "Trakt.h"

@implementation Episode

@synthesize poster;
@synthesize tvdbID;
@synthesize showTitle;
@synthesize title;
@synthesize description;
@synthesize network;
@synthesize airtime;
@synthesize season;
@synthesize number;

- (id)initWithDictionary:(NSDictionary *)episodeInfo {
  if (self = [super init]) {
    // TODO Running the specs without making copies here crashes.
    // Need to check if that's something to do with NuBacon or an actual bug we haven't seen yet.
    self.tvdbID       = [[episodeInfo valueForKeyPath:@"show.tvdb_id"] copy];
    self.showTitle    = [[episodeInfo valueForKeyPath:@"show.title"] copy];
    self.title        = [[episodeInfo valueForKeyPath:@"episode.title"] copy];
    self.description  = [[episodeInfo valueForKeyPath:@"episode.overview"] copy];
    self.network      = [[episodeInfo valueForKeyPath:@"show.network"] copy];
    self.airtime      = [[episodeInfo valueForKeyPath:@"show.air_time"] copy];
    self.season       = [[episodeInfo valueForKeyPath:@"episode.season"] integerValue];
    self.number       = [[episodeInfo valueForKeyPath:@"episode.number"] integerValue];
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
  [poster release];
  [tvdbID release];
  [title release];
  [description release];
  [network release];
  [airtime release];
  [showTitle release];
}

- (NSString *)episodeNumber {
  return [NSString stringWithFormat:@"%dx%02d", self.season, self.number, nil];
}

- (NSString *)serieTitleAndEpisodeNumber {
  return [NSString stringWithFormat:@"%@ %@", self.showTitle, [self episodeNumber], nil];
}

- (NSString *)airTimeAndChannel {
  return [NSString stringWithFormat:@"%@ on %@", self.airtime, self.network, nil];
}

- (UIImage *)image {
  return [UIImage imageNamed:@"episode.jpg"];
}

- (void)ensureShowPosterIsLoaded:(void (^)())downloadedBlock {
  // important to first check if we already have the poster loaded for performance!
  if (self.poster == nil) {
    [[Trakt sharedInstance] showPosterForTVDBId:tvdbID block:^(UIImage *thePoster, BOOL cached) {
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
