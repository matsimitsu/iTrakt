#import <Foundation/Foundation.h>
#import "BroadcastDate.h"

@interface Episode : NSObject {
  id delegate;
  BroadcastDate *broadcastDate;

  NSData *downloadData;

  NSDictionary *showInfo;

  UIImage *poster;
  NSString *showTitle;
  NSString *tvdbID;
  NSString *title;
  NSUInteger season;
  NSUInteger number;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BroadcastDate *broadcastDate;

@property (nonatomic, retain) UIImage *poster;
@property (nonatomic, retain) NSString *tvdbID;
@property (nonatomic, retain) NSString *showTitle;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSUInteger season;
@property (nonatomic, assign) NSUInteger number;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSString *)serieTitleAndEpisodeNumber;

@end
