#import <Foundation/Foundation.h>

@interface BroadcastDate : NSObject {
  NSDate *date;
  NSArray *episodes;
  NSDictionary *dict;
}

@property (retain) NSDate *date;
@property (retain) NSArray *episodes;
@property (retain) NSDictionary *dict;

- (id)initWithDate:(NSDate *)date episodes:(NSArray *)episodes;
- (id)initWithDictionary:(NSDictionary *)dict;

@end
