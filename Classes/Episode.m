#import "Episode.h"
#import "EGOCache.h"

@implementation Episode

@synthesize delegate;
@synthesize broadcastDate;

@synthesize banner;
@synthesize bannerURL;
@synthesize bannerData;

@synthesize poster;

@synthesize tvdbID;
@synthesize title;
@synthesize season;
@synthesize number;

- (id)initWithDictionary:(NSDictionary *)dict broadcastDate:(BroadcastDate *)broadcastDate delegate:(id)delegate {
  if (self = [super init]) {
    episodeDict = nil;

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
      downloadData = [[EGOCache currentCache] dataForKey:tvdbID];
      episodeDict = [downloadData yajl_JSON];
      [self loadPoster];
    } else {
      downloadData = [[NSMutableData data] retain];
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

- (NSString *)posterPNGFilename {
  return [NSString stringWithFormat:@"%@.png", tvdbID, nil];
}

- (void)loadPoster {
  if ([[EGOCache currentCache] hasCacheForKey:[self posterPNGFilename]]) {
    NSLog(@"Loading poster from cache with tvdb ID `%@'", tvdbID);
    self.poster = [UIImage imageWithData:[[EGOCache currentCache] dataForKey:[self posterPNGFilename]]];
  } else {
    NSString *posterURL = [episodeDict valueForKey:@"poster"];
    NSLog(@"Start poster download for tvdb ID `%@' from: %@", tvdbID, posterURL);
    downloadData = [[NSMutableData data] retain];
    NSURL *url = [NSURL URLWithString:posterURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  if (episodeDict) {
    NSLog(@"Poster data download finished!");
    self.poster = [UIImage imageWithData:downloadData];
    [[EGOCache currentCache] setImage:poster forKey:[self posterPNGFilename]];
  } else {
    NSLog(@"Episode data download finished!");
    episodeDict = [downloadData yajl_JSON];
    [[EGOCache currentCache] setData:downloadData forKey:tvdbID];
  }
  [downloadData release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Data download failed: %@", [error localizedDescription]);
  [downloadData release];
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
