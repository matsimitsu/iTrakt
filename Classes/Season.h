#import <Foundation/Foundation.h>

@interface Season : NSObject {
  NSInteger number;
  NSMutableArray *episodes;
}

@property (nonatomic, retain) NSMutableArray *episodes;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSString *)label;

@end
