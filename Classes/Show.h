#import <Foundation/Foundation.h>

@interface Show : NSObject {
  NSString *tvdbID;
  NSString *title;
  NSUInteger year;
}

@property (nonatomic, retain) NSString *tvdbID;
@property (nonatomic, retain) NSString *title;
@property (assign) NSUInteger year;

- (id)initWithDictionary:(NSDictionary *)showDict;

@end
