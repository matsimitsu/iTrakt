#import "HTTPDownload.h"
#import "Trakt.h"
#import "Show.h"
#import "Episode.h"

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


static void callNuBlockWithArguments(id nuBlock, NSArray *arguments) {
  id args = [arguments performSelector:@selector(list)];
  id context = [nuBlock performSelector:@selector(context)];
  [nuBlock performSelector:@selector(evalWithArguments:context:) withObject:args withObject:context];
}


@implementation Show (SpecHelper)

- (void)ensurePosterIsLoadedWithNuBlock:(id)nuBlock {
  [self ensurePosterIsLoaded:^{
    callNuBlockWithArguments(nuBlock, [NSArray array]);
  }];
}

- (void)ensureSeasonsAreLoadedWithNuBlock:(id)nuBlock {
  [self ensureSeasonsAreLoaded:^{
    callNuBlockWithArguments(nuBlock, [NSArray array]);
  }];
}

@end


@implementation Episode (SpecHelper)

- (void)ensureShowPosterIsLoadedWithNuBlock:(id)nuBlock {
  [self ensureShowPosterIsLoaded:^{
    callNuBlockWithArguments(nuBlock, [NSArray array]);
  }];
}

- (void)ensureThumbIsLoadedWithNuBlock:(id)nuBlock {
  [self ensureThumbIsLoaded:^{
    callNuBlockWithArguments(nuBlock, [NSArray array]);
  }];
}

- (void)toggleSeenWithNuBlock:(id)nuBlock {
  [self toggleSeen:^{
    callNuBlockWithArguments(nuBlock, [NSArray array]);
  }];
}

@end


@implementation Trakt (SpecHelper)

- (void)calendarWithNuBlock:(id)nuBlock {
  [self calendar:^(NSArray *dates) {
    callNuBlockWithArguments(nuBlock, [NSArray arrayWithObject:dates]);
  }];
}

- (void)libraryWithNuBlock:(id)nuBlock {
  [self library:^(NSArray *shows) {
    callNuBlockWithArguments(nuBlock, [NSArray arrayWithObject:shows]);
  }];
}

- (void)trendingWithNuBlock:(id)nuBlock {
  [self trending:^(NSArray *shows) {
    callNuBlockWithArguments(nuBlock, [NSArray arrayWithObject:shows]);
  }];
}
- (void)showPosterForURL:(NSURL *)posterURL nuBlock:(id)nuBlock {
  [self showPosterForURL:posterURL block:^(UIImage *poster, BOOL cached) {
    callNuBlockWithArguments(nuBlock, [NSArray arrayWithObjects:poster, [NSNumber numberWithBool:cached], nil]);
  }];
}

- (void)showThumbForURL:(NSURL *)thumbURL nuBlock:(id)nuBlock {
  [self showThumbForURL:thumbURL block:^(UIImage *thumb, BOOL cached) {
    callNuBlockWithArguments(nuBlock, [NSArray arrayWithObjects:thumb, [NSNumber numberWithBool:cached], nil]);
  }];
}

- (void)loadImageFromURL:(NSURL *)URL nuBlock:(id)nuBlock {
  [self loadImageFromURL:URL block:^(UIImage *image, BOOL cached) {
    callNuBlockWithArguments(nuBlock, [NSArray arrayWithObjects:image, [NSNumber numberWithBool:cached], nil]);
  }];
}

@end


@implementation HTTPDownload (SpecHelper)

+ (id)downloadFromURL:(NSURL *)theURL nuBlock:(id)nuBlock {
  return [self downloadFromURL:theURL block:^(id response) {
    id args = [[NSArray arrayWithObject:response] performSelector:@selector(list)];
    id context = [nuBlock performSelector:@selector(context)];
    [nuBlock performSelector:@selector(evalWithArguments:context:) withObject:args withObject:context];
  }];
}

+ (id)downloadFromURL:(NSURL *)theURL username:(NSString *)username password:(NSString *)password nuBlock:(id)nuBlock {
  return [self downloadFromURL:theURL username:username password:password block:^(id response) {
    id args = [[NSArray arrayWithObject:response] performSelector:@selector(list)];
    id context = [nuBlock performSelector:@selector(context)];
    [nuBlock performSelector:@selector(evalWithArguments:context:) withObject:args withObject:context];
  }];
}

@end
