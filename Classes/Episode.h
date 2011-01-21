#import <Foundation/Foundation.h>

@interface Episode : NSObject {
  UIImage *banner;
  NSString *title;
  NSUInteger season;
  NSUInteger number;
}

@property (nonatomic, retain) UIImage *banner;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSUInteger season;
@property (nonatomic, assign) NSUInteger number;

- (id)initWithTitle:(NSString *)title season:(NSUInteger)season number:(NSUInteger)number banner:(UIImage *)banner;

@end
