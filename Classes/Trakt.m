#import <YAJL/YAJL.h>

#import "Trakt.h"
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
  NSLog(@"[!] Start download of calendar data");
  [JSONDownload downloadFromURL:[self calendarURL] block:^(id response) {
    NSLog(@"[!] Finished download of calendar data");
    NSMutableArray *dates = [NSMutableArray array];
    for(NSDictionary *item in (NSArray *)response) {
      [dates addObject:[[[BroadcastDate alloc] initWithDictionary:item delegate:nil] autorelease]];
    }
    block([dates copy]);
  }];
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
