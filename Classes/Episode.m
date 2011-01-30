#import "Episode.h"
#import "EGOCache.h"
#import <YAJL/YAJL.h>

#import "Trakt.h"

@implementation Episode

@synthesize poster;
@synthesize thumb;
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
    self.network      = [[episodeInfo valueForKeyPath:@"show.network"] copy];
    self.airtime      = [[episodeInfo valueForKeyPath:@"show.air_time"] copy];
    self.season       = [[episodeInfo valueForKeyPath:@"episode.season"] integerValue];
    self.number       = [[episodeInfo valueForKeyPath:@"episode.number"] integerValue];

    id d = [episodeInfo valueForKeyPath:@"episode.overview"];
    if ([NSNull null] != d) {
      self.description = [d copy];
    }
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
  [poster release];
  [thumb release];
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

- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock {
  // important to first check if we already have the thumb loaded for performance!
  if (self.thumb == nil) {
    [[Trakt sharedInstance] showThumbForTVDBId:tvdbID season:season episode:number block:^(UIImage *theThumb, BOOL cached) {
      self.thumb = theThumb;
      if (!cached) {
        //NSLog(@"Downloaded episode thumb with tvdb ID: %@", tvdbID);
        downloadedBlock();
      }
      //else {
        //NSLog(@"Loaded show episode thumb cache with tvdb ID: %@", tvdbID);
      //}
    }];
  }
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
