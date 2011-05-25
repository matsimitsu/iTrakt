#import "Episode.h"
#import "Trakt.h"
#import "Show.h"

@implementation Episode

@synthesize thumb;
@synthesize seen;

- (id)initWithDictionary:(NSDictionary *)episodeInfo {
  // Keep a strong reference to the show, as it is a 'child' association
  Show *s = [[Show alloc] initWithDictionary:[episodeInfo valueForKey:@"show"]];
  if ([self initWithShow:s episodeInfo:episodeInfo]) {
    ownsShow = YES;
  } else {
    [s release];
  }
  return self;
}

- (id)initWithShow:(Show *)theShow episodeInfo:(NSDictionary *)episodeInfo {
  if (self = [super init]) {
    // TODO why is the watched field not inside the episode hash in the calendar feed?
    seen = [[episodeInfo valueForKey:@"watched"] boolValue];
    dictionary = [[episodeInfo valueForKey:@"episode"] retain];
    // Keep a weak reference to the show, as it is as 'parent' association.
    ownsShow = NO;
    show = theShow;
  }
  return self;
}


- (void)dealloc {
  [dictionary release];
  if (ownsShow) {
    [show release];
  }
  [thumb release];
  [super dealloc];
}


// Depending on how the Episode was initialized, this might be a weak reference.
- (Show *)show {
  return show;
}

- (NSString *)title {
  return [dictionary valueForKey:@"title"];
}

- (NSURL *)thumbURL {
  return [NSURL URLWithString:[dictionary valueForKey:@"thumb"]];
}

- (NSInteger)season {
  return [[dictionary valueForKey:@"season"] integerValue];
}

- (NSInteger)number {
  return [[dictionary valueForKey:@"number"] integerValue];
}

- (NSString *)overview {
  if ([NSNull null] != [dictionary objectForKey:@"overview"]) {
    return [dictionary valueForKey:@"overview"];
  }
  return nil;
}

- (NSString *)episodeAndSeason {
  return [NSString stringWithFormat:@"Episode %d, Season %d", self.number, self.season];
}

// TODO is this still being used?
- (NSString *)episodeNumber {
  return [NSString stringWithFormat:@"%dx%02d", self.season, self.number];
}

- (NSString *)serieTitleAndEpisodeNumber {
  return [NSString stringWithFormat:@"%@ %@", [self episodeNumber], [show title]];
}


- (void)toggleSeen:(void (^)())requestCompletedBlock {
  [[Trakt sharedInstance] toggleSeenForEpisode:self block:requestCompletedBlock];
}

- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock {
  // important to first check if we already have the thumb loaded for performance!
  if (self.thumb == nil) {
    NSLog(@"THUMB URL: %@", self.thumbURL);
    [[Trakt sharedInstance] showThumbForURL:self.thumbURL block:^(UIImage *theThumb, BOOL cached) {
      self.thumb = theThumb;
      if (!cached) {
        //NSLog(@"Downloaded episode thumb with tvdb ID: %@", tvdbID);
        downloadedBlock();
      }
      else {
        NSLog(@"Loaded show episode thumb from cache!");
      }
    }];
  }
}

@end
