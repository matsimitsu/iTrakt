#import <Foundation/Foundation.h>

@interface Show : NSObject {
  NSString *tvdbID;
  NSString *title;
  NSUInteger year;
  NSURL *posterURL;
  UIImage *poster;
}

@property (nonatomic, retain) NSString *tvdbID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *posterURL;
@property (nonatomic, retain) UIImage *poster;
@property (assign) NSUInteger year;

- (id)initWithDictionary:(NSDictionary *)showDict;

// TODO this should come from the JSON and be stored in a property, but for now I'm hardcoding it.
- (NSURL *)posterURL;

- (void)ensurePosterIsLoaded:(void (^)())downloadedBlock;

@end
