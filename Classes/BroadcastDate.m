//
//  BroadcastDate.m
//  iTrakt
//
//  Created by Robert Beekman on 21-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BroadcastDate.h"
#include <HTTPRiot/HTTPRiot.h>

@implementation BroadcastDate

@synthesize date;
@synthesize episodes;

- (id)initWithDate:(NSDate *)date episodes:(NSArray *)episodes
{
  if (self = [super init]) {
    self.date = date;
    self.episodes = episodes;

    return self;
  }
  return nil;
}

@end
