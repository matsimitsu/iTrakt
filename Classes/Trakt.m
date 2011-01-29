#import "Trakt.h"

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

@synthesize delegate;
@synthesize URL;

- (id)initWithURL:(NSURL *)theURL delegate:(id)theDelegate {
  if (self = [super init]) {
    self.URL = theURL;
    delegate = theDelegate;
  }
  return self;
}

@end
