#import "Episode.h"
#import "EGOCache.h"

@implementation Episode

@synthesize delegate;
@synthesize broadcastDate;

@synthesize banner;
@synthesize bannerURL;
@synthesize bannerData;
@synthesize title;
@synthesize season;
@synthesize number;

- (id)initWithDictionary:(NSDictionary *)dict broadcastDate:(BroadcastDate *)broadcastDate delegate:(id)delegate {
  if (self = [super init]) {
    self.broadcastDate = broadcastDate;
    self.delegate = delegate;

    self.title = [dict valueForKeyPath:@"episode.title"];
    self.season = (int) [dict valueForKeyPath:@"episode.season"];
    self.number = (int) [dict valueForKeyPath:@"episode.number"];

    self.bannerURL = [dict valueForKeyPath:@"show.banner"];

    if ([[EGOCache currentCache] hasCacheForKey:[self.bannerURL lastPathComponent]]) {
      //NSLog(@"Banner was cached!");
      self.banner = [UIImage imageWithData:[[EGOCache currentCache] dataForKey:[self.bannerURL lastPathComponent]]];
    } else {
      //NSLog(@"Start image download: %@", self.bannerURL);
      self.bannerData = [NSMutableData data];
      NSURL *url = [NSURL URLWithString:self.bannerURL];
      NSURLRequest *request = [NSURLRequest requestWithURL:url];
      [NSURLConnection connectionWithRequest:request delegate:self];
    }
  }
  return self;
}

- (NSString *)numberText {
  return [NSString stringWithFormat:@"%dx%02d", season, number, nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [bannerData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  //NSLog(@"Connection finished!");
  self.banner = [UIImage imageWithData:bannerData];
  [bannerData release];
  [[EGOCache currentCache] setImage:self.banner forKey:[self.bannerURL lastPathComponent]];
  [self.delegate performSelector:@selector(episodeDidLoadBanner:) withObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Image download failed: %@", [error localizedDescription]);
  [bannerData release];
}

@end
