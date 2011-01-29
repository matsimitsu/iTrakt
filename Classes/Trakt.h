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
  NSMutableData *downloadData;
  void (^block)(NSData *response);
}

- (id)initWithURL:(NSURL *)theURL block:(void (^)(NSData *response))theBlock;

- (void)yieldDownloadedData;

@end

@interface JSONDownload : HTTPDownload
@end

@interface ImageDownload : HTTPDownload
@end
