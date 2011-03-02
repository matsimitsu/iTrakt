#import <Foundation/Foundation.h>
#import "BroadcastDate.h"
#import "Show.h"

@interface Episode : NSObject {
  NSDictionary *dictionary;
  Show *show;
  BOOL ownsShow;
  UIImage *thumb;
  BOOL seen;
}

@property (nonatomic, retain) UIImage *thumb;
@property (nonatomic, assign) BOOL seen;

- (id)initWithDictionary:(NSDictionary *)episodeInfo;
- (id)initWithShow:(Show *)theShow episodeInfo:(NSDictionary *)episodeInfo;

- (Show *)show;

- (NSString *)title;
- (NSURL *)thumbURL;
- (NSInteger)season;
- (NSInteger)number;
- (NSString *)overview;

- (NSString *)episodeNumber;
- (NSString *)serieTitleAndEpisodeNumber;

- (void)toggleSeen:(void (^)())requestCompletedBlock;

- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock;

@end
