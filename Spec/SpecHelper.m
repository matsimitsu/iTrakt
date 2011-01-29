#import "Trakt.h"

@interface Helper : NSObject {
}

+ (NSString *)stringFromUTF8Data:(NSData *)data;

+ (BOOL)image:(UIImage *)image1 equalToImage:(UIImage *)image2;

@end

@implementation Helper

+ (NSString *)stringFromUTF8Data:(NSData *)data {
  NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)image:(UIImage *)image1 equalToImage:(UIImage *)image2 {
  return [UIImagePNGRepresentation(image1) isEqualToData:UIImagePNGRepresentation(image2)];
}

@end

@interface HTTPDownload (SpecHelper)

+ (id)downloadFromURL:(NSURL *)theURL nuBlock:(id)nuBlock;

@end

@implementation HTTPDownload (SpecHelper)

+ (id)downloadFromURL:(NSURL *)theURL nuBlock:(id)nuBlock {
  return [self downloadFromURL:theURL block:^(NSData *response) {
    id args = [[NSArray arrayWithObject:response] performSelector:@selector(list)];
    id context = [nuBlock performSelector:@selector(context)];
    [nuBlock performSelector:@selector(evalWithArguments:context:) withObject:args withObject:context];
  }];
}

@end
