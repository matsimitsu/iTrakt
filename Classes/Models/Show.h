#import <Foundation/Foundation.h>

@interface Show : NSObject {
  NSDictionary *dictionary;
  NSArray *seasons;
  UIImage *poster;
  UIImage *thumb;
}

@property (nonatomic, retain) NSArray *seasons;
@property (nonatomic, retain) UIImage *poster;
@property (nonatomic, retain) UIImage *thumb;

- (id)initWithDictionary:(NSDictionary *)showInfo;

- (NSString *)tvdbID;
- (NSString *)title;
- (NSString *)overview;
- (NSString *)network;
- (NSURL *)thumbURL;
- (NSURL *)posterURL;
- (NSInteger)year;
- (NSInteger)watchers;
- (NSDate *)airtime;
- (NSString *)localizedAirtime;
- (NSString *)airtimeAndChannel;
- (NSString *)seasonsAndEpisodes;

- (void)ensurePosterIsLoaded:(void (^)())downloadedBlock;
- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock;
- (void)ensureSeasonsAreLoaded:(void (^)())downloadedBlock;
@end
