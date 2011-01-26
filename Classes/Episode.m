#import "Episode.h"
#import "EGOCache.h"
#import <YAJL/YAJL.h>

@implementation Episode

@synthesize delegate;
@synthesize broadcastDate;

@synthesize poster;
@synthesize tvdbID;
@synthesize showTitle;
@synthesize title;
@synthesize season;
@synthesize number;

- (id)initWithDictionary:(NSDictionary *)episodeInfo broadcastDate:(BroadcastDate *)theBroadcastDate delegate:(id)theDelegate {
  if (self = [super init]) {
    showInfo = nil;

    self.broadcastDate = theBroadcastDate;
    self.delegate = theDelegate;

    self.tvdbID    = [episodeInfo valueForKeyPath:@"show.tvdb_id"];
    self.showTitle = [episodeInfo valueForKeyPath:@"show.title"];
    self.title     = [episodeInfo valueForKeyPath:@"episode.title"];
    self.season    = [[episodeInfo valueForKeyPath:@"episode.season"] integerValue];
    self.number    = [[episodeInfo valueForKeyPath:@"episode.number"] integerValue];

    [self loadEpisodeData];
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
  [poster release];
  [tvdbID release];
  [title release];
  [showTitle release];
  [showInfo release];
}

- (NSString *)episodeNumber {
  return [NSString stringWithFormat:@"%dx%02d", season, number, nil];
}

- (NSString *)serieTitleAndEpisodeNumber {
  return [NSString stringWithFormat:@"%@ %@", showTitle, [self episodeNumber], nil];
}

// TODO this has to be added to the calendar API
- (NSString *)airTimeAndChannel {
  return @"8:00pm on FOX";
}

- (NSString *)posterPNGFilename {
  return [NSString stringWithFormat:@"%@.png", tvdbID, nil];
}

- (UIImage *)image {
  return [UIImage imageNamed:@"episode.jpg"];
}

- (NSString *)description {
  return @"When the Fringe Team visits Massive Dynamic’s assembly of the doomsday device, Walter becomes greatly concerned for Peter’s well-being, so he turns to Nina for added brain power to understand the relationship between Peter and the superweapon. Meanwhile, the discovery of a dead body triggers an intense investigation.";
}

- (void)loadEpisodeData {
  NSString *apiKey = @"6ce9688a2fd3316355204b1d25d44f00";

  if ([[EGOCache currentCache] hasCacheForKey:tvdbID]) {
    NSLog(@"Load episode data from cache for tvdb ID `%@'", tvdbID);
    NSData *episodeData = [[EGOCache currentCache] dataForKey:tvdbID];
    showInfo = [[episodeData yajl_JSON] retain];
    [self loadPoster];
  } else {
    downloadData = [[NSMutableData data] retain];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.trakt.tv/show/summary.json/%@/%@", apiKey, tvdbID, nil]];
    NSLog(@"Download episode data for tvdb ID `%@'", tvdbID);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
  }
}

- (void)loadPoster {
  if ([[EGOCache currentCache] hasCacheForKey:[self posterPNGFilename]]) {
    NSLog(@"Loading poster from cache with tvdb ID `%@'", tvdbID);
    self.poster = [UIImage imageWithData:[[EGOCache currentCache] dataForKey:[self posterPNGFilename]]];
  } else {
    NSString *posterURL = [showInfo valueForKey:@"poster"];
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
  if (showInfo) {
    NSLog(@"Poster data download finished!");
    self.poster = [UIImage imageWithData:downloadData];
    [[EGOCache currentCache] setImage:poster forKey:[self posterPNGFilename]];
    [downloadData release];
    [delegate performSelector:@selector(episodeDidLoadPoster:) withObject:self];
  } else {
    NSLog(@"Show data download finished!");
    showInfo = [[downloadData yajl_JSON] retain];
    [[EGOCache currentCache] setData:downloadData forKey:tvdbID];
    [downloadData release];
    [self loadPoster];
  }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Data download failed: %@", [error localizedDescription]);
  [downloadData release];
}

@end
