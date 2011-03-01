#import <Foundation/Foundation.h>
#import "Show.h"

@interface Season : NSObject {
  NSInteger number;
  NSMutableArray *episodes;
}

@property (nonatomic, retain) NSMutableArray *episodes;

- (id)initWithShow:(Show *)show seasonInfo:(NSDictionary *)dict;

- (NSString *)label;

@end
