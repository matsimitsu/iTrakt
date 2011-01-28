#import "Trakt.h"

@implementation Trakt

static id sharedTrakt = nil;

+ (Trakt *)sharedInstance{
  if (sharedTrakt == nil) {
    sharedTrakt = [[Trakt alloc] init];
  }
  return sharedTrakt;
}

@synthesize apiKey;

@end
