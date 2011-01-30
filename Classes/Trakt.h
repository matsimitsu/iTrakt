#import <Foundation/Foundation.h>

#define BASE_URL @"http://itrakt.matsimitsu.com"

@interface Trakt : NSObject {
  NSString *baseURL;

  NSString *apiKey;
  NSString *apiUser;
}

@property (nonatomic, retain) NSString *baseURL;

@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *apiUser;

+ (Trakt *)sharedInstance;

- (NSURL *)calendarURL;
- (void)calendar:(void (^)(NSArray *broadcastDates))block;

- (NSURL *)showPosterURLForTVDBId:(NSString *)tvdbID;
- (void)showPosterForTVDBId:(NSString *)tvdbID block:(void (^)(UIImage *poster, BOOL cached))block;

- (NSURL *)showThumbURLForTVDBId:(NSString *)tvdbID season:(NSInteger)season episode:(NSInteger)episode;
- (void)showThumbForTVDBId:(NSString *)tvdbID season:(NSInteger)season episode:(NSInteger)episode block:(void (^)(UIImage *thumb, BOOL cached))block;


- (UIImage *)cachedImageForURL:(NSURL *)URL;
- (void)removeCachedImageForURL:(NSURL *)URL;
- (void)loadImageFromURL:(NSURL *)URL block:(void (^)(UIImage *image, BOOL cached))block;

@end

@interface HTTPDownload : NSObject {
  NSMutableData *downloadData;
  void (^block)(id response);
}

+ (id)downloadFromURL:(NSURL *)theURL block:(void (^)(id response))theBlock;

- (id)initWithURL:(NSURL *)theURL block:(void (^)(id response))theBlock;

- (void)yieldDownloadedData;

@end

@interface JSONDownload : HTTPDownload
@end

@interface ImageDownload : HTTPDownload
@end
