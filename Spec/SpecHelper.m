#import "Trakt.h"

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
