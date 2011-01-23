//
//  BroadcastDate.h
//  iTrakt
//
//  Created by Robert Beekman on 21-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BroadcastDate : HRRestModel {
  NSDate *date;
  NSArray *episodes;
  NSDictionary *dict;
}

@property (retain) NSDate *date;
@property (retain) NSArray *episodes;
@property (retain) NSDictionary *dict;

- (id)initWithDate:(NSDate *)date episodes:(NSArray *)episodes;
- (id)initWithDictionary:(NSDictionary *)dict;

@end
