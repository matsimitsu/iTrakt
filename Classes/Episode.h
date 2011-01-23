#import <Foundation/Foundation.h>
#import "BroadcastDate.h"

@interface Episode : NSObject {
  id delegate;
  BroadcastDate *broadcastDate;
  UIImage *banner;
  NSData *bannerData;
  NSString *title;
  NSUInteger season;
  NSUInteger number;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BroadcastDate *broadcastDate;
@property (nonatomic, retain) UIImage *banner;
@property (nonatomic, retain) NSData *bannerData;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSUInteger season;
@property (nonatomic, assign) NSUInteger number;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSString *)numberText;

@end
