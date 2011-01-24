#import "Episode.h"
#import "EGOCache.h"

@implementation Episode

@synthesize delegate;
@synthesize broadcastDate;

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

    self.tvdbID = [dict valueForKeyPath:@"show.tvdb_id"];
    self.title  = [dict valueForKeyPath:@"episode.title"];
    self.season = [[dict valueForKeyPath:@"episode.season"] integerValue];
    self.number = [[dict valueForKeyPath:@"episode.number"] integerValue];

    [self loadEpisodeData];
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

- (void)loadEpisodeData {
  NSString *apiKey = @"6ce9688a2fd3316355204b1d25d44f00";

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

@end
