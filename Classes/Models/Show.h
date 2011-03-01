#import <Foundation/Foundation.h>

@interface Show : NSObject {
  NSDictionary *dictionary;

  NSArray *seasons;
  UIImage *poster;
  UIImage *thumb;
}

@property (nonatomic, retain) NSDictionary *dictionary;

@property (nonatomic, retain) NSArray *seasons;
@property (nonatomic, retain) UIImage *poster;
@property (nonatomic, retain) UIImage *thumb;

- (id)initWithDictionary:(NSDictionary *)showDict;

- (NSString *)tvdbID;
- (NSString *)title;
- (NSString *)overview;
- (NSURL *)thumbURL;
- (NSURL *)posterURL;
- (NSInteger)year;
- (NSInteger)watchers;

- (void)ensurePosterIsLoaded:(void (^)())downloadedBlock;
- (void)ensureThumbIsLoaded:(void (^)())downloadedBlock;
- (void)ensureSeasonsAreLoaded:(void (^)())downloadedBlock;
@end
