//
//  BroadcastCalendar.h
//  iTrakt
//
//  Created by Robert Beekman on 21-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <HTTPRiot/HTTPRiot.h>


@interface BroadcastCalendar : HRRestModel {
  NSString *username;
  NSArray *broadcastDates;
}

@property (retain) NSString *username;
@property (retain) NSArray *broadcastDates;

- (id)initWithDates:(NSArray *)broadcastDates;

@end
