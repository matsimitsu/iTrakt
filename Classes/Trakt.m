#import <YAJL/YAJL.h>
#import "EGOCache.h"
#import "UIImage+Resize.h"
#import <CommonCrypto/CommonDigest.h>

#import "Trakt.h"
#import "BroadcastDate.h"

#import "Show.h"
#import "Episode.h"

@implementation Trakt

static Trakt *sharedTrakt = nil;

+ (Trakt *)sharedInstance{
  if (sharedTrakt == nil) {
    sharedTrakt = [[Trakt alloc] init];
    sharedTrakt.baseURL = BASE_URL;
  }
  return sharedTrakt;
}

@synthesize baseURL;

@synthesize apiUser;
@synthesize apiPasswordHash;

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

- (NSURL *)calendarURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/calendar.json?name=%@", self.baseURL, self.apiUser, nil]];
}

- (void)calendar:(void (^)(NSArray *broadcastDates))block {
  //NSLog(@"[!] Start download of calendar data");
  [JSONDownload downloadFromURL:[self calendarURL] block:^(id response) {
    //NSLog(@"[!] Finished download of calendar data");
    NSMutableArray *dates = [NSMutableArray array];
    for(NSDictionary *episodeDict in (NSArray *)response) {
      [dates addObject:[[[BroadcastDate alloc] initWithDictionary:episodeDict] autorelease]];
    }
    block([dates copy]);
  }];
}

- (NSURL *)libraryURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/library.json?name=%@", self.baseURL, self.apiUser, nil]];
}

- (void)library:(void (^)(NSArray *shows))block {
  //NSLog(@"[!] Start download of calendar data from: %@", [self libraryURL]);
  [JSONDownload downloadFromURL:[self libraryURL] block:^(id response) {
    //NSLog(@"[!] Finished download of calendar data");
    NSMutableArray *shows = [NSMutableArray array];
    for(NSDictionary *showDict in (NSArray *)response) {
      [shows addObject:[[[Show alloc] initWithDictionary:showDict] autorelease]];
    }
    block([shows copy]);
  }];
}

- (NSURL *)trendingURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/shows/trending.json", self.baseURL, nil]];
}

- (void)trending:(void (^)(NSArray *shows))block {
  //NSLog(@"[!] Start download of calendar data from: %@", [self libraryURL]);
  [JSONDownload downloadFromURL:[self trendingURL] block:^(id response) {
    //NSLog(@"[!] Finished download of calendar data");
    NSMutableArray *shows = [NSMutableArray array];
    for(NSDictionary *showDict in (NSArray *)response) {
      [shows addObject:[[[Show alloc] initWithDictionary:showDict] autorelease]];
    }
    block([shows copy]);
  }];
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
  //NSLog(@"Cache key: %@", filename);
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
  if (cachedImage) {
    block(cachedImage, YES);
  } else {
    // download from the actual URL, not the scaled down identifier
    [ImageDownload downloadFromURL:URL block:^(id image) {
      UIImage *result = (UIImage *)image;
      if (!CGSizeEqualToSize(scaledTo, CGSizeZero)) {
        result = [[result normalize] resizedImage:scaledTo interpolationQuality:kCGInterpolationHigh];
      }
      [[EGOCache currentCache] setImage:result forKey:[_URL lastPathComponent]];
      block(result, NO);
    }];
  }
}


@end

@implementation HTTPDownload

+ (id)downloadFromURL:(NSURL *)theURL block:(void (^)(id response))theBlock {
  return [[[self alloc] initWithURL:theURL block:theBlock] autorelease];
}

- (id)initWithURL:(NSURL *)theURL block:(void (^)(id response))theBlock {
  if (self = [super init]) {
    downloadData = nil;
    block = Block_copy(theBlock);
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:theURL] delegate:self];
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
  Block_release(block);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  downloadData = [[NSMutableData data] retain];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  [self yieldDownloadedData];
  [downloadData release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Data download failed: %@", [error localizedDescription]);
  if (downloadData) {
    [downloadData release];
  }
}

- (void)yieldDownloadedData {
  block([downloadData copy]);
}

@end

@implementation JSONDownload

- (void)yieldDownloadedData {
  block([downloadData yajl_JSON]);
}

@end

@implementation ImageDownload

- (void)yieldDownloadedData {
  block([UIImage imageWithData:downloadData]);
}

@end
