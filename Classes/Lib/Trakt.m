#import "EGOCache.h"
#import "HTTPDownload.h"
#import <CommonCrypto/CommonDigest.h>

#import "Trakt.h"
#import "BroadcastDate.h"

#import "Season.h"
#import "Show.h"
#import "Episode.h"

@implementation Trakt

static Trakt *sharedTrakt = nil;

+ (Trakt *)sharedInstance{
  if (sharedTrakt == nil) {
    sharedTrakt = [[Trakt alloc] init];
    sharedTrakt.baseURL = BASE_URL;
    sharedTrakt.traktBaseURL = TRAKT_BASE_URL;
  }
  return sharedTrakt;
}

@synthesize baseURL;
@synthesize traktBaseURL;

@synthesize apiUser;
@synthesize apiKey;
@synthesize apiPasswordHash;

@synthesize broadcastDates, library, recommendations;

- (void)setApiPassword:(NSString *)password {
  const char *cstr = [password cStringUsingEncoding:NSUTF8StringEncoding];
  NSData *data = [NSData dataWithBytes:cstr length:[password length]];

  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  CC_SHA1([data bytes], [data length], digest);

  NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
    [result appendFormat:@"%02x", digest[i]];
  }
  apiPasswordHash = [[result copy] retain];
}

- (void)retrieveRootControllerDataStartingWith:(NSString *)dataDownloadSelector block:(void (^)(NSArray *data))block {
  NSMutableArray *selectors = [NSMutableArray arrayWithObjects:@"calendar:", @"library:", @"recommendations:", nil];
  [selectors removeObject:dataDownloadSelector];
  [self performSelector:NSSelectorFromString(dataDownloadSelector) withObject:block];
  for (NSString *selector in selectors) {
    [self performSelector:NSSelectorFromString(selector) withObject:nil];
  }
}

- (NSURL *)verifyCredentialsURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/account/test/%@", self.traktBaseURL, self.apiKey]];
}

- (void)verifyCredentials:(void (^)(BOOL valid))block {
  NSString *json = [NSString stringWithFormat:@"{ \"username\": \"%@\", \"password\": \"%@\" }", self.apiUser, self.apiPasswordHash];
  JSONDownload *dl = [[JSONDownload alloc] initWithURL:[self verifyCredentialsURL] postBody:json username:nil password:nil block:^(id response) {
    NSString *status = (NSString *)[(NSDictionary *)response objectForKey:@"status"];
    if (status && [status isEqualToString:@"success"]) {
      block(YES);
    } else {
      block(NO);
    }
  }];
  dl.reportConnectionStatus = NO;
  [dl start];
  [dl autorelease];
}

- (NSURL *)calendarURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/calendar.json", self.baseURL]];
}

- (void)calendar:(void (^)(NSArray *broadcastDates))block {
  [JSONDownload downloadFromURL:[self calendarURL] username:self.apiUser password:self.apiPasswordHash block:^(id response) {
    NSMutableArray *dates = [NSMutableArray array];
    for(NSDictionary *episodeDict in (NSArray *)response) {
      BroadcastDate *d = [[BroadcastDate alloc] initWithDictionary:episodeDict];
      [dates addObject:d];
      [d release];
    }
    self.broadcastDates = [[dates copy] autorelease];
    if (block) {
      block(broadcastDates);
    }
  }];
}

- (NSURL *)libraryURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/library.json", self.baseURL]];
}

- (void)library:(void (^)(NSArray *shows))block {
  [JSONDownload downloadFromURL:[self libraryURL] username:self.apiUser password:self.apiPasswordHash block:^(id response) {
    NSMutableArray *shows = [NSMutableArray array];
    for(NSDictionary *showDict in (NSArray *)response) {
      Show *s = [[Show alloc] initWithDictionary:showDict];
      [shows addObject:s];
      [s release];
    }
    self.library = [[shows copy] autorelease];
    if (block) {
      block(library);
    }
  }];
}

- (NSURL *)recommendationsURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/shows/recommendations.json", self.baseURL]];
}

- (void)recommendations:(void (^)(NSArray *shows))block {
  [JSONDownload downloadFromURL:[self recommendationsURL] username:self.apiUser password:self.apiPasswordHash block:^(id response) {
    NSMutableArray *shows = [NSMutableArray array];
    for(NSDictionary *showDict in (NSArray *)response) {
      Show *s = [[Show alloc] initWithDictionary:showDict];
      [shows addObject:s];
      [s release];
    }
    self.recommendations = [[shows copy] autorelease];
    if (block) {
      block(recommendations);
    }
  }];
}


- (NSURL *)seasonsURL:(NSString *)tvdb_id {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/shows/%@/seasons_with_episodes.json", self.baseURL, tvdb_id]];
}

- (void)seasons:(Show *)show block:(void (^)(NSArray *seasons))block {
  [JSONDownload downloadFromURL:[self seasonsURL:show.tvdbID] username:self.apiUser password:self.apiPasswordHash block:^(id response) {
    NSMutableArray *seasons = [NSMutableArray array];
    for(NSDictionary *seasonDict in (NSArray *)response) {
      Season *s = [[Season alloc] initWithShow:show seasonInfo:seasonDict];
      [seasons addObject:s];
      [s release];
    }
    block([[seasons copy] autorelease]);
  }];
}

- (NSURL *)episodeSeenURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/show/episode/seen/%@", self.traktBaseURL, self.apiKey]];
}

- (NSURL *)episodeNotSeenURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/show/episode/unseen/%@", self.traktBaseURL, self.apiKey]];
}

- (void)toggleSeenForEpisode:(Episode *)episode block:(void (^)())block {
  NSURL *url = episode.seen ? [self episodeNotSeenURL] : [self episodeSeenURL];
  // Using YAJL for this really seems like overdoing it
  NSString *json = [NSString stringWithFormat:@"{ \"username\":\"%@\", \"password\":\"%@\", \"tvdb_id\":\"%@\", \"episodes\":[{ \"season\":%d, \"episode\":%d }] }",
                                              self.apiUser, self.apiPasswordHash, [episode.show tvdbID], episode.season, episode.number];
  [HTTPDownload postToURL:url body:json username:self.apiUser password:self.apiPasswordHash block:^(id response) {
    episode.seen = !episode.seen;
    block();
  }];
}


- (UIImage *)cachedShowPosterForURL:(NSURL *)posterURL {
  return [self cachedImageForURL:posterURL scaledTo:CGSizeMake(44.0, 66.0)];
}

- (void)showPosterForURL:(NSURL *)posterURL block:(void (^)(UIImage *poster, BOOL cached))block {
  [self loadImageFromURL:posterURL scaledTo:CGSizeMake(44.0, 66.0) block:block];
}

- (void)showThumbForURL:(NSURL *)thumbURL block:(void (^)(UIImage *thumb, BOOL cached))block {
  [self loadImageFromURL:thumbURL block:block];
}


# pragma The abstracted methods that deal with the API

- (NSURL *)URLForImageURL:(NSURL *)URL scaledTo:(CGSize)scaledTo {
  NSURL *_URL = URL;
  if (!CGSizeEqualToSize(scaledTo, CGSizeZero)) {
    NSString *filename = [NSString stringWithFormat:@"%dx%d-%@", (int)scaledTo.width, (int)scaledTo.height, [_URL lastPathComponent]];
    _URL = [[_URL URLByDeletingLastPathComponent] URLByAppendingPathComponent:filename];
  }
  return _URL;
}

- (UIImage *)cachedImageForURL:(NSURL *)URL {
  return [self cachedImageForURL:URL scaledTo:CGSizeZero];
}

- (UIImage *)cachedImageForURL:(NSURL *)URL scaledTo:(CGSize)scaledTo {
  NSURL *_URL = [self URLForImageURL:URL scaledTo:scaledTo];
  NSString *filename = [_URL lastPathComponent];
  if ([[EGOCache currentCache] hasCacheForKey:filename]) {
     return [UIImage imageWithData:[[EGOCache currentCache] dataForKey:filename]];
  } else {
    return nil;
  }
}

- (void)removeCachedImageForURL:(NSURL *)URL {
  [[EGOCache currentCache] removeCacheForKey:[URL lastPathComponent]];
}

- (void)removeCachedImageForURL:(NSURL *)URL scaledTo:(CGSize)scaledTo {
  [self removeCachedImageForURL:[self URLForImageURL:URL scaledTo:scaledTo]];
}

- (void)loadImageFromURL:(NSURL *)URL block:(void (^)(UIImage *image, BOOL cached))block {
  [self loadImageFromURL:URL scaledTo:CGSizeZero block:block];
}

- (void)loadImageFromURL:(NSURL *)URL scaledTo:(CGSize)scaledTo block:(void (^)(UIImage *image, BOOL cached))block {
  NSURL *_URL = [self URLForImageURL:URL scaledTo:scaledTo];

  UIImage *cachedImage = [self cachedImageForURL:_URL];
  //UIImage *cachedImage = nil; // Force download for debugging purposes.
  if (cachedImage) {
    block(cachedImage, YES);
  } else {
    // download from the actual URL, not the scaled down identifier
    [ImageDownload downloadFromURL:URL resizeTo:scaledTo block:^(id image) {
      [[EGOCache currentCache] setImage:image forKey:[_URL lastPathComponent]];
      block(image, NO);
    }];
  }
}


@end
