#import <Foundation/Foundation.h>

@interface Trakt : NSObject {
  NSString *apiKey;
}

@property (nonatomic, retain) NSString *apiKey;

+ (Trakt *)sharedInstance;

@end
