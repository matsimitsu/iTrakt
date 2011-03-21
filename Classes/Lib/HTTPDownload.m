#import "HTTPDownload.h"

#import "Base64.h"
#import <YAJL/YAJL.h>
#import <dispatch/dispatch.h>
#import "UIImage+Resize.h"

@implementation HTTPDownload

static id globalDelegate = nil;

+ (id)globalDelegate {
  return globalDelegate;
}

+ (void)setGlobalDelegate:(id)delegate {
  globalDelegate = delegate;
}


static NSMutableSet *inProgress = nil;

+ (NSMutableSet *)inProgress {
  if (inProgress == nil) {
    inProgress = [[NSMutableSet set] retain];
  }
  return inProgress;
}

+ (void)downloadInProgress:(HTTPDownload *)download {
  if ([[HTTPDownload inProgress] count] == 0 && [globalDelegate respondsToSelector:@selector(downloadsAreInProgress)]) {
    [globalDelegate performSelector:@selector(downloadsAreInProgress)];
  }
  [[HTTPDownload inProgress] addObject:download];
}

+ (void)downloadFinished:(HTTPDownload *)download {
  [[HTTPDownload inProgress] removeObject:download];
  if ([[HTTPDownload inProgress] count] == 0 && [globalDelegate respondsToSelector:@selector(downloadsAreFinished)]) {
    [globalDelegate performSelector:@selector(downloadsAreFinished)];
  }
}


+ (id)downloadFromURL:(NSURL *)theURL block:(void (^)(id response))theBlock {
  return [[[self alloc] initWithURL:theURL postBody:nil username:nil password:nil block:theBlock] autorelease];
}

+ (id)downloadFromURL:(NSURL *)theURL username:(NSString *)username password:(NSString *)password block:(void (^)(id response))theBlock {
  return [[[self alloc] initWithURL:theURL postBody:nil username:username password:password block:theBlock] autorelease];
}

+ (id)postToURL:(NSURL *)theURL body:(NSString *)body username:(NSString *)username password:(NSString *)password block:(void (^)(id response))theBlock {
  return [[[self alloc] initWithURL:theURL postBody:body username:username password:password block:theBlock] autorelease];
}


+ (void)cancelDownloadsInProgress {
  NSSet *inProgress = [[HTTPDownload inProgress] copy];
  [inProgress makeObjectsPerformSelector:@selector(cancel)];
  [inProgress release];
}


@synthesize downloadData;
@synthesize connection;
@synthesize response;
@synthesize error;

- (id)initWithURL:(NSURL *)theURL postBody:(NSString *)body username:(NSString *)username password:(NSString *)password block:(void (^)(id response))theBlock {
  if (self = [super init]) {
    downloadData = nil;
    block = Block_copy(theBlock);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];

    if (body) {
      [request setHTTPMethod:@"POST"];
      [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (username && password) {
      NSData *data = [[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding];
      [request setValue:[NSString stringWithFormat:@"Basic %@", [Base64 encode:data]] forHTTPHeaderField:@"Authorization"];
      //NSLog(@"Sending basic-auth data: %@", [NSString stringWithFormat:@"Basic %@", [Base64 encode:data]]);
    }

    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [HTTPDownload downloadInProgress:self];
  }
  return self;
}


- (void)dealloc {
  self.downloadData = nil;
  self.connection = nil;
  self.response = nil;
  self.error = nil;

  [super dealloc];
  Block_release(block);
}


- (void)cancel {
  [self.connection cancel];
  [HTTPDownload downloadFinished:self];
}


- (BOOL)errorOcurred {
  return self.error == nil ? NO : YES;
}

- (NSString *)errorMessage {
  if (self.error) {
    return [error localizedDescription];
  } else if (self.response) {
    return [NSString stringWithFormat:@"Response %d, %@.",
                                      [response statusCode],
                                      [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],
                                      nil];
  }
  return nil;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)theResponse {
  self.response = theResponse;
  self.downloadData = [NSMutableData data];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [downloadData appendData:data];
}

// The only status codes a HTTP server should responde with are >= 200 and < 600.
- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
  [HTTPDownload downloadFinished:self];

  NSInteger status = [self.response statusCode];
  //NSLog(@"Connection received status %d", status);
  if (status >= 200 && status < 300) {
    [self yieldDownloadedData];
  } else if (status >= 300 && status < 400) {
    NSLog(@"[!] Redirect response, which we don't (atm have to) handle. Where did it come from?");
  } else {
    if ([globalDelegate respondsToSelector:@selector(downloadFailed:)]) {
      [globalDelegate performSelector:@selector(downloadFailed:) withObject:self];
    }
  }
}


- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)theError {
  [HTTPDownload downloadFinished:self];

  self.error = theError;
  if ([globalDelegate respondsToSelector:@selector(downloadFailed:)]) {
    [globalDelegate performSelector:@selector(downloadFailed:) withObject:self];
  }
}


- (void)yieldDownloadedData {
  block([[downloadData copy] autorelease]);
}


@end


@implementation JSONDownload

- (void)yieldDownloadedData {
  NSLog(@"JSON: %@", [[NSString alloc] initWithData:downloadData encoding:NSUTF8StringEncoding]);
  block([downloadData yajl_JSON]);
}

@end


@implementation ImageDownload

static dispatch_queue_t imageQueue = NULL;

@synthesize resizeTo;

+ (id)downloadFromURL:(NSURL *)theURL resizeTo:(CGSize)resizeToSize block:(void (^)(id response))theBlock {
  return [[[self alloc] initWithURL:theURL resizeTo:resizeToSize block:theBlock] autorelease];
}

- (id)init {
  if (self = [super init]) {
    self.resizeTo = CGSizeZero;
  }
  return self;
}


- (id)initWithURL:(NSURL *)theURL resizeTo:(CGSize)resizeToSize block:(void (^)(id response))theBlock {
  if (self = [super initWithURL:theURL postBody:nil username:nil password:nil block:theBlock]) {
    if (imageQueue == NULL) {
      imageQueue = dispatch_queue_create("com.matsimitsu.iTrakt.imageQueue", NULL);
    }
    self.resizeTo = resizeToSize;
  }
  return self;
}


- (void)yieldDownloadedData {
  UIImage *result = [UIImage imageWithData:downloadData];
  if (CGSizeEqualToSize(self.resizeTo, CGSizeZero)) {
    //NSLog(@"NOT RESIZING!");
    block(result);
  } else {
    // NSLog(@"Dispatch image resizing!");
    dispatch_async(imageQueue, ^{
      // TODO get rid of the normalizing!
      UIImage *resized = [result resizedImage:self.resizeTo interpolationQuality:kCGInterpolationHigh];
      dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"Done resizing, dispatching to main thread!");
        block(resized);
      });
    });
  }
}


@end

