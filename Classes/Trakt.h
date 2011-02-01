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

- (NSURL *)libraryURL;
- (void)library:(void (^)(NSArray *shows))block;

- (void)showPosterForURL:(NSURL *)posterURL block:(void (^)(UIImage *poster, BOOL cached))block;

- (void)showThumbForURL:(NSURL *)thumbURL block:(void (^)(UIImage *thumb, BOOL cached))block;

- (NSURL *)URLForImageURL:(NSURL *)URL scaledTo:(CGSize)scaledTo;

- (UIImage *)cachedImageForURL:(NSURL *)URL;
- (UIImage *)cachedImageForURL:(NSURL *)URL scaledTo:(CGSize)scaledTo;

- (void)removeCachedImageForURL:(NSURL *)URL;
- (void)removeCachedImageForURL:(NSURL *)URL scaledTo:(CGSize)scaledTo;

- (void)loadImageFromURL:(NSURL *)URL block:(void (^)(UIImage *image, BOOL cached))block;
- (void)loadImageFromURL:(NSURL *)URL scaledTo:(CGSize)scaledTo block:(void (^)(UIImage *image, BOOL cached))block;

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
