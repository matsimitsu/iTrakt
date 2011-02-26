#import <Foundation/Foundation.h>

@interface BroadcastDate : NSObject {
  NSDate *date;
  NSArray *episodes;
}

@property (retain) NSDate *date;
@property (retain) NSArray *episodes;

//- (id)initWithDate:(NSDate *)date episodes:(NSArray *)episodes;
- (id)initWithDictionary:(NSDictionary *)dict;

@end
