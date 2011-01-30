#import <Foundation/Foundation.h>
#import "BroadcastDate.h"

@interface Episode : NSObject {
  UIImage *poster;
  UIImage *thumb;
  NSString *showTitle;
  NSString *tvdbID;
  NSString *title;
  NSString *description;
  NSString *network;
  NSString *airtime;
  NSUInteger season;
  NSUInteger number;
}

@property (nonatomic, retain) UIImage *poster;
@property (nonatomic, retain) UIImage *thumb;
@property (nonatomic, retain) NSString *tvdbID;
@property (nonatomic, retain) NSString *showTitle;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *network;
@property (nonatomic, retain) NSString *airtime;
@property (nonatomic, assign) NSUInteger season;
@property (nonatomic, assign) NSUInteger number;

- (id)initWithDictionary:(NSDictionary *)episodeInfo;

- (NSString *)episodeNumber;
- (NSString *)serieTitleAndEpisodeNumber;

- (NSString *)airTimeAndChannel;

- (void)ensureShowPosterIsLoaded:(void (^)())downloadedBlock;
- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock;

@end
