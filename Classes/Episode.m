#import "Episode.h"

@implementation Episode

@synthesize delegate;
@synthesize broadcastDate;

@synthesize banner;
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

    self.bannerData = [NSMutableData data];

    //NSLog(@"Start image download: %@", [dict valueForKeyPath:@"show.banner"]);
    NSURL *url = [NSURL URLWithString:[dict valueForKeyPath:@"show.banner"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
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
  [self.delegate performSelector:@selector(episodeDidLoadBanner:) withObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Image download failed: %@", [error localizedDescription]);
  [bannerData release];
}

@end
