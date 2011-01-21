//
//  BroadcastDate.h
//  iTrakt
//
//  Created by Robert Beekman on 21-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BroadcastDate : NSObject {
  NSDate *date;
  NSArray *episodes;
}

@property (retain) NSDate *date;
@property (retain) NSArray *episodes;

- (id)initWithDate:(NSDate *)date episodes:(NSArray *)episodes;

@end
