#import "Episode.h"
#import "Trakt.h"
#import "Show.h"

@implementation Episode

@synthesize poster;
@synthesize thumb;
@synthesize posterURL;
@synthesize thumbURL;
@synthesize tvdbID;
@synthesize showTitle;
@synthesize title;
@synthesize overview;
@synthesize network;
@synthesize airtime;
@synthesize season;
@synthesize number;
@synthesize seen;

- (id)initWithDictionary:(NSDictionary *)episodeInfo {
  if (self = [super init]) {
    // TODO Running the specs without making copies here crashes.
    // Need to check if that's something to do with NuBacon or an actual bug we haven't seen yet.
    self.posterURL    = [NSURL URLWithString:[episodeInfo valueForKeyPath:@"show.poster"]];
    self.thumbURL     = [NSURL URLWithString:[episodeInfo valueForKeyPath:@"episode.thumb"]];
    self.tvdbID       = [[episodeInfo valueForKeyPath:@"show.tvdb_id"] copy];
    self.showTitle    = [[episodeInfo valueForKeyPath:@"show.title"] copy];
    self.title        = [[episodeInfo valueForKeyPath:@"episode.title"] copy];
    self.network      = [[episodeInfo valueForKeyPath:@"show.network"] copy];
    self.season       = [[episodeInfo valueForKeyPath:@"episode.season"] integerValue];
    self.number       = [[episodeInfo valueForKeyPath:@"episode.number"] integerValue];
    self.seen         = [[episodeInfo valueForKey:@"watched"] boolValue];

    NSDateFormatter *dateReader = [[NSDateFormatter alloc] init];
    [dateReader setDateFormat:@"HH:mm:ss"];
    [dateReader setTimeZone:[NSTimeZone timeZoneWithAbbreviation: @"EST"]];
    self.airtime = [dateReader dateFromString:[episodeInfo valueForKeyPath:@"show.air_time"]];
    [dateReader release];

    id o = [episodeInfo valueForKeyPath:@"episode.overview"];
    if ([NSNull null] != o) {
      self.overview = [o copy];
    }
  }
  return self;
}


- (id)initWithDictionary:(NSDictionary *)episodeInfo show:(Show *)show {
  if (self = [super init]) {
    // TODO Running the specs without making copies here crashes.
    // Need to check if that's something to do with NuBacon or an actual bug we haven't seen yet.
    self.posterURL    = show.posterURL;
    self.thumbURL     = [NSURL URLWithString:[episodeInfo valueForKeyPath:@"thumb"]];
    self.tvdbID       = show.tvdbID;
    self.showTitle    = show.title;
    self.title        = [[episodeInfo valueForKeyPath:@"title"] copy];
   // self.network      = show.network;
    self.season       = [[episodeInfo valueForKeyPath:@"season"] integerValue];
    self.number       = [[episodeInfo valueForKeyPath:@"episode"] integerValue];

  /*
    NSDateFormatter *dateReader = [[NSDateFormatter alloc] init];
    [dateReader setDateFormat:@"HH:mm:ss"];
    [dateReader setTimeZone:[NSTimeZone timeZoneWithAbbreviation: @"EST"]];
    self.airtime = [dateReader dateFromString:[episodeInfo valueForKeyPath:@"show.air_time"]];
    [dateReader release];
  */
    id o = [episodeInfo valueForKeyPath:@"overview"];
    if ([NSNull null] != o) {
      self.overview = [o copy];
    }
  }
  return self;
}


- (void)dealloc {
  [super dealloc];
  [poster release];
  [thumb release];
  [posterURL release];
  [thumbURL release];
  [tvdbID release];
  [title release];
  [overview release];
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

- (NSString *)localizedAirTime {
  NSDateFormatter *dateWriter = [[NSDateFormatter alloc] init];
  //[dateWriter setDateFormat:@"hh:mma"];
  [dateWriter setTimeStyle:NSDateFormatterShortStyle];
  [dateWriter setDateStyle:NSDateFormatterNoStyle];
  [dateWriter setTimeZone:[NSTimeZone systemTimeZone]];
  NSString *dateString = [dateWriter stringFromDate:self.airtime];
  [dateWriter release];
  return dateString;
}

- (NSString *)airTimeAndChannel {
  return [NSString stringWithFormat:@"%@ on %@", [self localizedAirTime], self.network, nil];
}

- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock {
  // important to first check if we already have the thumb loaded for performance!
  if (self.thumb == nil) {
    [[Trakt sharedInstance] showThumbForURL:self.thumbURL block:^(UIImage *theThumb, BOOL cached) {
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

- (UIImage *)poster {
  if (poster == nil) {
    poster = [[[Trakt sharedInstance] cachedShowPosterForURL:self.posterURL] retain];
  }
  return poster;
}

- (void)ensureShowPosterIsLoaded:(void (^)())downloadedBlock {
  // important to first check if we already have the poster loaded for performance!
  if (self.poster == nil) {
    [[Trakt sharedInstance] showPosterForURL:self.posterURL block:^(UIImage *thePoster, BOOL cached) {
      self.poster = thePoster;
      downloadedBlock();
    }];
  }
}

@end
