#import <Foundation/Foundation.h>

@interface Show : NSObject {
  NSString *tvdbID;
  NSString *title;
  NSString *overview;
  NSUInteger year;
  NSURL *posterURL;
  NSURL *thumbURL;
  NSArray *seasons;
  UIImage *poster;
  UIImage *thumb;
}

@property (nonatomic, retain) NSString *tvdbID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *overview;
@property (nonatomic, retain) NSURL *posterURL;
@property (nonatomic, retain) NSURL *thumbURL;
@property (nonatomic, retain) NSArray *seasons;
@property (nonatomic, retain) UIImage *poster;
@property (nonatomic, retain) UIImage *thumb;
@property (assign) NSUInteger year;

- (id)initWithDictionary:(NSDictionary *)showDict;

- (void)ensurePosterIsLoaded:(void (^)())downloadedBlock;
- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock;
- (void)ensureSeasonsAreLoaded:(void (^)())downloadedBlock;
@end
