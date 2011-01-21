#import <Foundation/Foundation.h>

@interface Episode : NSObject {
  UIImage *banner;
  NSString *title;
  NSUInteger season;
  NSUInteger number;
}

@property (retain) UIImage *banner;
@property (retain) NSString *title;
@property (assign) NSUInteger season;
@property (assign) NSUInteger number;

- (id)initWithTitle:(NSString *)title season:(NSUInteger)season number:(NSUInteger)number banner:(UIImage *)banner;

@end
