#import "Show.h"
#import "Trakt.h"

@implementation Show

@synthesize seasons;
@synthesize poster;
@synthesize thumb;

- (id)initWithDictionary:(NSDictionary *)showInfo {
  if ((self = [super init])) {
    dictionary = [showInfo retain];
  }
  return self;
}

- (void)dealloc {
  [dictionary release];
  [seasons release];
  [thumb release];
  [poster release];
  [super dealloc];
}


- (NSString *)tvdbID {
  return [dictionary valueForKey:@"tvdb_id"];
}

- (NSString *)title {
  return [dictionary valueForKey:@"title"];
}

- (NSString *)overview {
  return [dictionary valueForKey:@"overview"];
}

- (NSString *)network {
  return [dictionary valueForKey:@"network"];
}

- (NSURL *)thumbURL {
  return [NSURL URLWithString:[dictionary valueForKey:@"thumb"]];
}

- (NSURL *)posterURL {
  if ([NSNull null] != [dictionary objectForKey:@"poster"]) {
    return [NSURL URLWithString:[dictionary valueForKey:@"poster"]];
  }
  return nil;
}

- (NSInteger)year {
  return [[dictionary valueForKey:@"year"] integerValue];
}

- (NSInteger)watchers {
  return [[dictionary valueForKey:@"watchers"] integerValue];
}

// TODO should we cache this?
- (NSDate *)airtime {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"HH:mm:ss"];
  [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation: @"EST"]];
  NSDate *airtime = [formatter dateFromString:[dictionary valueForKey:@"air_time"]];
  [formatter release];
  return airtime;
}

- (NSString *)localizedAirtime {
  NSDateFormatter *dateWriter = [[NSDateFormatter alloc] init];
  //[dateWriter setDateFormat:@"hh:mma"];
  [dateWriter setTimeStyle:NSDateFormatterShortStyle];
  [dateWriter setDateStyle:NSDateFormatterNoStyle];
  [dateWriter setTimeZone:[NSTimeZone systemTimeZone]];
  NSString *dateString = [dateWriter stringFromDate:[self airtime]];
  [dateWriter release];
  return dateString;
}

- (NSString *)airtimeAndChannel {
  return [NSString stringWithFormat:@"%@ on %@", [self localizedAirtime], [self network], nil];
}

- (NSString *)seasonsAndEpisodes {
  NSNumber *seasonCount = [dictionary objectForKey:@"season_count"];
  NSNumber *episodeCount = [dictionary objectForKey:@"episode_count"];
  if ([NSNull null] != (id)seasonCount && [seasonCount intValue] > 0 &&
        [NSNull null] != (id)episodeCount && [episodeCount intValue] > 0) {
    return [NSString stringWithFormat:@"%d Seasons, %d Episodes", [seasonCount intValue], [episodeCount intValue]];
  }
  return @"Episodes";
}


- (void)ensureSeasonsAreLoaded:(void (^)())downloadedBlock {
  // important to first check if we already have the poster loaded for performance!
  if (self.seasons == nil) {
    [[Trakt sharedInstance] seasons:self block:^(NSArray *theSeasons) {
      self.seasons = theSeasons;
      downloadedBlock();
    }];
  }
}

- (UIImage *)poster {
  if (self.posterURL == nil) {
    return [UIImage imageNamed:@"placeholder-portrait"];
  }
  if (poster == nil) {
    poster = [[[Trakt sharedInstance] cachedShowPosterForURL:self.posterURL] retain];
    if (poster == nil) {
      return [UIImage imageNamed:@"placeholder-portrait"];
    }
  }
  return poster;
}

- (UIImage *)thumb {
  return thumb == nil ? [UIImage imageNamed:@"placeholder-landscape"] : thumb;
}

- (void)ensurePosterIsLoaded:(void (^)())downloadedBlock {
  // important to first check if we already have the poster loaded for performance!
  if (poster == nil && self.posterURL != nil) {
    [[Trakt sharedInstance] showPosterForURL:self.posterURL block:^(UIImage *thePoster, BOOL cached) {
      self.poster = thePoster;
      downloadedBlock();
    }];
  }
}

- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock {
  // important to first check if we already have the thumb loaded for performance!
  if (thumb == nil) {
    [[Trakt sharedInstance] showThumbForURL:self.thumbURL block:^(UIImage *theThumb, BOOL cached) {
      self.thumb = theThumb;
      if (!cached) {
        downloadedBlock();
      }
    }];
  }
}


@end
