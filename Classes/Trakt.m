#import "Trakt.h"
#import <YAJL/YAJL.h>

@implementation Trakt

static id sharedTrakt = nil;

+ (Trakt *)sharedInstance{
  if (sharedTrakt == nil) {
    sharedTrakt = [[Trakt alloc] init];
  }
  return sharedTrakt;
}

@synthesize apiKey;
@synthesize apiUser;

- (NSString *)baseURL {
  return BASE_URL;
}

- (NSString *)calendarURL {
  return [NSString stringWithFormat:@"%@/user/calendar/shows.json/%@/%@", BASE_URL, self.apiKey, self.apiUser, nil];
}

@end

@implementation HTTPDownload

- (id)initWithURL:(NSURL *)theURL block:(void (^)(NSData *response))theBlock {
  if (self = [super init]) {
    downloadData = nil;
    block = Block_copy(theBlock);
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:theURL] delegate:self];
  }
  return self;
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
