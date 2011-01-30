#import <YAJL/YAJL.h>

#import "Trakt.h"
#import "EGOCache.h"
#import "BroadcastDate.h"

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

@synthesize apiKey;
@synthesize apiUser;

- (NSURL *)calendarURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/calendar.json?name=%@", self.baseURL, self.apiUser, nil]];
}

- (void)calendar:(void (^)(NSArray *broadcastDates))block {
  //NSLog(@"[!] Start download of calendar data");
  [JSONDownload downloadFromURL:[self calendarURL] block:^(id response) {
    //NSLog(@"[!] Finished download of calendar data");
    NSMutableArray *dates = [NSMutableArray array];
    for(NSDictionary *item in (NSArray *)response) {
      [dates addObject:[[[BroadcastDate alloc] initWithDictionary:item delegate:nil] autorelease]];
    }
    block([dates copy]);
  }];
}


- (NSURL *)showPosterURLForTVDBId:(NSString *)tvdbID {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/uploads/show/poster/%@.jpg", self.baseURL, tvdbID, nil]];
}

- (void)showPosterForTVDBId:(NSString *)tvdbID block:(void (^)(UIImage *poster, BOOL cached))block {
  [self loadImageFromURL:[self showPosterURLForTVDBId:tvdbID] block:block];
}


- (UIImage *)cachedImageForURL:(NSURL *)URL {
  NSString *filename = [URL lastPathComponent];
  //NSLog(@"Cache key: %@", filename);
  if ([[EGOCache currentCache] hasCacheForKey:filename]) {
     return [UIImage imageWithData:[[EGOCache currentCache] dataForKey:filename]];
  } else {
    return nil;
  }
}

- (void)loadImageFromURL:(NSURL *)URL block:(void (^)(UIImage *image, BOOL cached))block {
  UIImage *cachedImage = [self cachedImageForURL:URL];
  if (cachedImage) {
    block(cachedImage, YES);
  } else {
    [ImageDownload downloadFromURL:URL block:^(id image) {
      [[EGOCache currentCache] setImage:(UIImage *)image forKey:[URL lastPathComponent]];
      block((UIImage *)image, NO);
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
