#import <Foundation/Foundation.h>

@interface Show : NSObject {
  NSString *tvdbID;
  NSString *title;
  NSUInteger year;
  UIImage *poster;
}

@property (nonatomic, retain) NSString *tvdbID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIImage *poster;
@property (assign) NSUInteger year;

- (id)initWithDictionary:(NSDictionary *)showDict;

@end
