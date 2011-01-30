#import "Episode.h"
#import "EGOCache.h"
#import <YAJL/YAJL.h>

#import "Trakt.h"

@implementation Episode

@synthesize delegate;
@synthesize broadcastDate;

@synthesize poster;
@synthesize tvdbID;
@synthesize showTitle;
@synthesize title;
@synthesize description;
@synthesize network;
@synthesize airtime;
@synthesize season;
@synthesize number;

- (id)initWithDictionary:(NSDictionary *)episodeInfo broadcastDate:(BroadcastDate *)theBroadcastDate delegate:(id)theDelegate {
  if (self = [super init]) {
    showInfo = nil;

    self.broadcastDate = theBroadcastDate;
    self.delegate = theDelegate;

    self.tvdbID       = [episodeInfo valueForKeyPath:@"show.tvdb_id"];
    self.showTitle    = [episodeInfo valueForKeyPath:@"show.title"];
    self.title        = [episodeInfo valueForKeyPath:@"episode.title"];
    self.description  = [episodeInfo valueForKeyPath:@"episode.overview"];
    self.network      = [episodeInfo valueForKeyPath:@"show.network"];
    self.airtime      = [episodeInfo valueForKeyPath:@"show.air_time"];
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
  [showInfo release];
}

- (NSString *)episodeNumber {
  return [NSString stringWithFormat:@"%dx%02d", season, number, nil];
}

- (NSString *)serieTitleAndEpisodeNumber {
  return [NSString stringWithFormat:@"%@ %@", showTitle, [self episodeNumber], nil];
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
