//
//  BroadcastCalendar.m
//  iTrakt
//
//  Created by Robert Beekman on 21-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BroadcastCalendar.h"
#include <HTTPRiot/HTTPRiot.h>

@implementation BroadcastCalendar

@synthesize username;
@synthesize broadcastDates;

+ (void)initialize {
  [self setDelegate:self];
  [self setBaseURL:[NSURL URLWithString:@"http://localhost:3000"]];
}

- (void)initWithDates:(NSArray *)broadcastDates {
    if(self = [super init]) {
      self.broadcastDates = broadcastDates;
    }
    return self;
}


#pragma mark - HRRequestOperation Delegates
+ (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error object:(id)object {
    // Handle connection errors.  Failures to connect to the server, etc.
}

+ (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error response:(NSHTTPURLResponse *)response object:(id)object {
    // Handle invalid responses, 404, 500, etc.
}

+ (void)restConnection:(NSURLConnection *)connection didReceiveParseError:(NSError *)error responseBody:(NSString *)string {
  NSLog(@"Parse error");
    // Request was successful, but couldn't parse the data returned by the server.
}

// Given I've passed the controller as the <tt>object</tt> here, I can call any method I want to on it
// giving it a collection of models I've initialized.
+ (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource  object:(id)object {
    NSMutableArray *dates = [[[NSMutableArray alloc] init] autorelease];
    NSLog(@"over here!");
    for(id item in resource) {
      NSLog([item description]);
        //[dates addItem:[[Broadcast alloc] initWithDictionary:item]];
    }

    //[object performSelector:@selector(tweetsLoaded:) withObject:tweets];
}

+ (id)getCalendar {
  return [self getPath:@"/users/calendar.json?name=matsimitsu" withOptions:nil object:nil];
}

@end

