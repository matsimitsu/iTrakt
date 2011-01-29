#import <Foundation/Foundation.h>

#define BASE_URL @"http://api.trakt.tv"

@interface Trakt : NSObject {
  NSString *apiKey;
  NSString *apiUser;
}

@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *apiUser;

+ (Trakt *)sharedInstance;

- (NSString *)baseURL;

@end

@interface HTTPDownload : NSObject {
  id delegate;
  NSURL *URL;
}

@property (readonly) id delegate;
@property (nonatomic, retain) NSURL *URL;

- (id)initWithURL:(NSURL *)theURL delegate:(id)theDelegate;

@end
