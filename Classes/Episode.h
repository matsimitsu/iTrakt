#import <Foundation/Foundation.h>
#import "BroadcastDate.h"
#import "Show.h"

@interface Episode : NSObject {
  UIImage *poster;
  UIImage *thumb;
  NSURL *posterURL;
  NSURL *thumbURL;
  NSString *showTitle;
  NSString *tvdbID;
  NSString *title;
  NSString *overview;
  NSString *network;
  NSDate *airtime;
  NSUInteger season;
  NSUInteger number;
}

@property (nonatomic, retain) UIImage *poster;
@property (nonatomic, retain) UIImage *thumb;
@property (nonatomic, retain) NSURL *posterURL;
@property (nonatomic, retain) NSURL *thumbURL;
@property (nonatomic, retain) NSString *tvdbID;
@property (nonatomic, retain) NSString *showTitle;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *overview;
@property (nonatomic, retain) NSString *network;
@property (nonatomic, retain) NSDate *airtime;
@property (nonatomic, assign) NSUInteger season;
@property (nonatomic, assign) NSUInteger number;

- (id)initWithDictionary:(NSDictionary *)episodeInfo;
- (id)initWithDictionary:(NSDictionary *)episodeInfo show:(Show *)show;

- (NSString *)episodeNumber;
- (NSString *)serieTitleAndEpisodeNumber;

- (NSString *)airTimeAndChannel;

- (void)ensureShowPosterIsLoaded:(void (^)())downloadedBlock;
- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock;

@end
