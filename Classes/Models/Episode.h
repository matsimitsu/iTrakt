#import <Foundation/Foundation.h>
#import "BroadcastDate.h"
#import "Show.h"

@interface Episode : NSObject {
  NSDictionary *dictionary;
  Show *show;
  UIImage *poster;
  UIImage *thumb;
  BOOL seen;
}

@property (nonatomic, retain) Show *show;
@property (nonatomic, retain) UIImage *poster;
@property (nonatomic, retain) UIImage *thumb;
@property (nonatomic, assign) BOOL seen;

- (id)initWithDictionary:(NSDictionary *)episodeInfo;

- (NSURL *)posterURL;
- (NSString *)tvdbID;
- (NSString *)showTitle;
- (NSString *)network;
- (NSDate *)airtime;
- (NSString *)localizedAirtime;
- (NSString *)airtimeAndChannel;

- (NSString *)title;
- (NSURL *)thumbURL;
- (NSInteger)season;
- (NSInteger)number;
- (NSString *)overview;

- (NSString *)episodeNumber;
- (NSString *)serieTitleAndEpisodeNumber;

- (void)toggleSeen:(void (^)())requestCompletedBlock;

- (void)ensureShowPosterIsLoaded:(void (^)())downloadedBlock;
- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock;

@end
