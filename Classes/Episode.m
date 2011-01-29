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
@synthesize description;
@synthesize network;
@synthesize airtime;
@synthesize season;
@synthesize number;
@synthesize posterUrl;

- (id)initWithDictionary:(NSDictionary *)episodeInfo broadcastDate:(BroadcastDate *)theBroadcastDate delegate:(id)theDelegate {
  if (self = [super init]) {
    showInfo = nil;

    self.broadcastDate = theBroadcastDate;
    self.delegate = theDelegate;

    self.tvdbID       = [episodeInfo valueForKeyPath:@"show.tvdb_id"];
    self.showTitle    = [episodeInfo valueForKeyPath:@"show.title"];
    self.title        = [episodeInfo valueForKeyPath:@"episode.title"];
    self.description  = [episodeInfo valueForKeyPath:@"episode.overview"];
    self.network      = [episodeInfo valueForKeyPath:@"show.network"];
    self.airtime      = [episodeInfo valueForKeyPath:@"show.air_time"];
    self.season       = [[episodeInfo valueForKeyPath:@"episode.season"] integerValue];
    self.number       = [[episodeInfo valueForKeyPath:@"episode.number"] integerValue];
    self.posterUrl    = [episodeInfo valueForKeyPath:@"show.poster"];
    [self loadPoster];
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
  [poster release];
  [tvdbID release];
  [title release];
  [description release];
  [network release];
  [airtime release];
  [showTitle release];
  [showInfo release];
  [posterUrl release];
}

- (NSString *)episodeNumber {
  return [NSString stringWithFormat:@"%dx%02d", season, number, nil];
}

- (NSString *)serieTitleAndEpisodeNumber {
  return [NSString stringWithFormat:@"%@ %@", showTitle, [self episodeNumber], nil];
}

- (NSString *)airTimeAndChannel {
  return [NSString stringWithFormat:@"%@ on %@", self.airtime, self.network, nil];
}

- (NSString *)posterPNGFilename {
  return [NSString stringWithFormat:@"%@.png", tvdbID, nil];
}

- (UIImage *)image {
  return [UIImage imageNamed:@"episode.jpg"];
}

- (void)loadPoster {
  if ([[EGOCache currentCache] hasCacheForKey:[self posterPNGFilename]]) {
    NSLog(@"Loading poster from cache with tvdb ID `%@'", tvdbID);
    self.poster = [UIImage imageWithData:[[EGOCache currentCache] dataForKey:[self posterPNGFilename]]];
  } else {
    NSLog(@"Start poster download for tvdb ID `%@' from: %@", tvdbID, self.posterUrl);
    downloadData = [[NSMutableData data] retain];
    NSURL *url = [NSURL URLWithString:self.posterUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSLog(@"Poster data download finished!");
  self.poster = [UIImage imageWithData:downloadData];
  [[EGOCache currentCache] setImage:poster forKey:[self posterPNGFilename]];
  [downloadData release];
  [delegate performSelector:@selector(episodeDidLoadPoster:) withObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Data download failed: %@", [error localizedDescription]);
  [downloadData release];
}

@end
