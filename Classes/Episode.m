#import "Episode.h"
#import "EGOCache.h"

@implementation Episode

@synthesize delegate;
@synthesize broadcastDate;

@synthesize banner;
@synthesize bannerURL;
@synthesize bannerData;

@synthesize poster;
@synthesize posterData;

@synthesize tvdbID;
@synthesize title;
@synthesize season;
@synthesize number;

- (id)initWithDictionary:(NSDictionary *)dict broadcastDate:(BroadcastDate *)broadcastDate delegate:(id)delegate {
  if (self = [super init]) {
    self.broadcastDate = broadcastDate;
    self.delegate = delegate;

    self.title = [dict valueForKeyPath:@"episode.title"];
    self.season = (NSUInteger)[[dict valueForKeyPath:@"episode.season"] integerValue];
    self.number = (NSUInteger)[[dict valueForKeyPath:@"episode.number"] integerValue];

    self.bannerURL = [dict valueForKeyPath:@"show.banner"];

    NSString *apiKey = @"6ce9688a2fd3316355204b1d25d44f00";
    self.tvdbID = [dict valueForKeyPath:@"show.tvdb_id"];

    //self.posterData = [NSMutableData data];

    if ([[EGOCache currentCache] hasCacheForKey:tvdbID]) {
      NSLog(@"Load episode data from cache for tvdb ID `%@'", tvdbID);
      episodeData = [[EGOCache currentCache] dataForKey:tvdbID];
      episodeDict = [[episodeData yajl_JSON] retain];
      [episodeData release];
    } else {
      episodeData = [[NSMutableData data] retain];
      NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.trakt.tv/show/summary.json/%@/%@", apiKey, tvdbID, nil]];
      NSLog(@"Download episode data from for tvdb ID `%@'", tvdbID);
      NSURLRequest *request = [NSURLRequest requestWithURL:url];
      [NSURLConnection connectionWithRequest:request delegate:self];
    }

    //NSLog(@"Start image download: %@", self.bannerURL);
    //if ([[EGOCache currentCache] hasCacheForKey:[self.bannerURL lastPathComponent]]) {
      ////NSLog(@"Banner was cached!");
      //self.banner = [UIImage imageWithData:[[EGOCache currentCache] dataForKey:[self.bannerURL lastPathComponent]]];
    //} else {
      ////NSLog(@"Start image download: %@", self.bannerURL);
      //self.bannerData = [NSMutableData data];
      //NSURL *url = [NSURL URLWithString:self.bannerURL];
      //NSURLRequest *request = [NSURLRequest requestWithURL:url];
      //[NSURLConnection connectionWithRequest:request delegate:self];
    //}
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
  [episodeDict release];
}

- (NSString *)numberText {
  return [NSString stringWithFormat:@"%dx%02d", season, number, nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [episodeData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSLog(@"Episode data download finished!");
  episodeDict = [[episodeData yajl_JSON] retain];
  [[EGOCache currentCache] setData:episodeData forKey:tvdbID];
  [episodeData release];
  //episodeDict = [[arrayFromData objectAtIndex:0] retain];
  //NSLog(@"%@", episodeDict);
  //[[EGOCache currentCache] setPlist:episodeDict forKey:[NSString stringWithFormat:@"%@.plist", tvdbID, nil]];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Episode data download failed: %@", [error localizedDescription]);
  [episodeData release];
}

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  //[bannerData appendData:data];
//}

//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  ////NSLog(@"Connection finished!");
  //self.banner = [UIImage imageWithData:bannerData];
  //[bannerData release];
  //[[EGOCache currentCache] setImage:self.banner forKey:[self.bannerURL lastPathComponent]];
  //[self.delegate performSelector:@selector(episodeDidLoadBanner:) withObject:self];
//}

//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  //NSLog(@"Image download failed: %@", [error localizedDescription]);
  //[bannerData release];
//}

@end
