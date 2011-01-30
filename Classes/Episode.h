#import <Foundation/Foundation.h>
#import "BroadcastDate.h"

@interface Episode : NSObject {
  id delegate;
  BroadcastDate *broadcastDate;

  NSDictionary *showInfo;

  UIImage *poster;
  NSString *showTitle;
  NSString *tvdbID;
  NSString *title;
  NSString *description;
  NSString *network;
  NSString *airtime;
  NSUInteger season;
  NSUInteger number;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BroadcastDate *broadcastDate;

@property (nonatomic, retain) UIImage *poster;
@property (nonatomic, retain) NSString *tvdbID;
@property (nonatomic, retain) NSString *showTitle;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *network;
@property (nonatomic, retain) NSString *airtime;
@property (nonatomic, assign) NSUInteger season;
@property (nonatomic, assign) NSUInteger number;

- (id)initWithDictionary:(NSDictionary *)episodeInfo broadcastDate:(BroadcastDate *)theBroadcastDate delegate:(id)theDelegate;

- (NSString *)episodeNumber;
- (NSString *)serieTitleAndEpisodeNumber;

- (NSString *)airTimeAndChannel;

// TODO for now just stubs
- (UIImage *)image;

- (void)ensureShowPosterIsLoaded:(void (^)())downloadedBlock;

@end
