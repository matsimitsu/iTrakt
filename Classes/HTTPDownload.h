#import <Foundation/Foundation.h>


@interface HTTPDownload : NSObject {
  NSURLConnection *connection;
  NSHTTPURLResponse *response;
  NSMutableData *downloadData;
  void (^block)(id response);
  NSError *error;
}

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, retain) NSError *error;

+ (id)globalDelegate;
+ (void)setGlobalDelegate:(id)delegate;

+ (id)downloadFromURL:(NSURL *)theURL block:(void (^)(id response))theBlock;

+ (void)cancelDownloadsInProgress;

- (id)initWithURL:(NSURL *)theURL block:(void (^)(id response))theBlock;

- (void)cancel;

- (BOOL)errorOcurred;

- (void)yieldDownloadedData;

@end


@interface JSONDownload : HTTPDownload
@end


@interface ImageDownload : HTTPDownload {
  CGSize resizeTo;
}

@property (nonatomic, assign) CGSize resizeTo;

+ (id)downloadFromURL:(NSURL *)theURL resizeTo:(CGSize)resizeToSize block:(void (^)(id response))theBlock;
- (id)initWithURL:(NSURL *)theURL resizeTo:(CGSize)resizeTo block:(void (^)(id response))theBlock;

@end
