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

+ (void)initialize {
  [self setDelegate:self];
  [self setBaseURL:[NSURL URLWithString:@"http://localhost:3000"]];
}

- (id)initWithDate:(NSDate *)date episodes:(NSArray *)episodes
{
  if (self = [super init]) {
    self.date = date;
    self.episodes = episodes;

    return self;
  }
  return nil;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if(self = [super init]) {

      NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
      dateFormatter.dateFormat = @"yyyy-mm-dd";

      self.date = [dateFormatter dateFromString:[dict valueForKeyPath:@"date"]];
      self.episodes = [dict valueForKey:@"episodes"];
    }

    return self;
}


+ (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource  object:(id)object {
    NSMutableArray *dates = [[[NSMutableArray alloc] init] autorelease];

    for(id item in resource) {
      [dates addObject:[[BroadcastDate alloc] initWithDictionary:item]];
    }

    // Let the tableview know we have new dates
    [object performSelector:@selector(datesLoaded:) withObject:dates];
}

+ (id)getDates:(id)object {
  return [self getPath:@"/users/calendar.json?name=matsimitsu" withOptions:nil object:object];
}


@end
