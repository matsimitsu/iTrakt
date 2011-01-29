#import "Trakt.h"

@interface SpecHelper : NSObject {
}

+ (BOOL)image:(UIImage *)image1 equalToImage:(UIImage *)image2;

@end

@implementation SpecHelper

+ (BOOL)image:(UIImage *)image1 equalToImage:(UIImage *)image2 {
  return [UIImagePNGRepresentation(image1) isEqualToData:UIImagePNGRepresentation(image2)];
}

@end

@interface HTTPDownload (SpecHelper)

- (id)initWithURL:(NSURL *)theURL nuBlock:(id)nuBlock;

@end

@implementation HTTPDownload (SpecHelper)

- (id)initWithURL:(NSURL *)theURL nuBlock:(id)nuBlock {
  return [self initWithURL:theURL block:^(NSData *response) {
    id args = [[NSArray arrayWithObject:response] performSelector:@selector(list)];
    id context = [nuBlock performSelector:@selector(context)];
    [nuBlock performSelector:@selector(evalWithArguments:context:) withObject:args withObject:context];
  }];
}

@end
