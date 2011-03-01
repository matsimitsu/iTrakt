#import "Episode.h"
#import "Trakt.h"
#import "Show.h"

@implementation Episode

@synthesize show;
@synthesize thumb;
@synthesize seen;

- (id)initWithDictionary:(NSDictionary *)episodeInfo {
  if (self = [super init]) {
    // TODO why is the watched field not inside the episode hash in the calendar feed?
    seen = [[episodeInfo valueForKey:@"watched"] boolValue];
    dictionary = [[episodeInfo valueForKey:@"episode"] retain];
    self.show = [[Show alloc] initWithDictionary:[episodeInfo valueForKey:@"show"]];
  }
  return self;
}

- (void)dealloc {
  [dictionary release];
  [show release];
  [thumb release];
  [super dealloc];
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

- (NSString *)episodeNumber {
  return [NSString stringWithFormat:@"%dx%02d", self.season, self.number, nil];
}

- (NSString *)serieTitleAndEpisodeNumber {
  return [NSString stringWithFormat:@"%@ %@", [self episodeNumber], [show title], nil];
}


- (void)toggleSeen:(void (^)())requestCompletedBlock {
  [[Trakt sharedInstance] toggleSeenForEpisode:self block:requestCompletedBlock];
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

@end
