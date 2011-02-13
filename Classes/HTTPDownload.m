#import "HTTPDownload.h"

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
  return [[[self alloc] initWithURL:theURL block:theBlock] autorelease];
}


+ (void)cancelDownloadsInProgress {
  NSSet *inProgress = [[HTTPDownload inProgress] copy];
  [inProgress makeObjectsPerformSelector:@selector(cancel)];
  [inProgress release];
}


@synthesize connection;
@synthesize response;
@synthesize error;

- (id)initWithURL:(NSURL *)theURL block:(void (^)(id response))theBlock {
  if (self = [super init]) {
    downloadData = nil;
    block = Block_copy(theBlock);
    self.connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:theURL] delegate:self];
    [HTTPDownload downloadInProgress:self];
  }
  return self;
}


- (void)dealloc {
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


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)theResponse {
  self.response = theResponse;
  downloadData = [[NSMutableData data] retain];
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
  [downloadData release];
}


- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)theError {
  [HTTPDownload downloadFinished:self];

  self.error = theError;
  if ([globalDelegate respondsToSelector:@selector(downloadFailed:)]) {
    [globalDelegate performSelector:@selector(downloadFailed:) withObject:self];
  }
  if (downloadData) {
    [downloadData release];
  }
}


- (void)yieldDownloadedData {
  block([[downloadData copy] autorelease]);
}


@end


@implementation JSONDownload

- (void)yieldDownloadedData {
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
  if (self = [super initWithURL:theURL block:theBlock]) {
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

