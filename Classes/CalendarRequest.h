#import <Foundation/Foundation.h>

@interface CalendarRequest : NSObject {
  id delegate;
  NSData *calendarData;

}

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) NSData *calendarData;

- (id)initAndGetDatesWithDelegate:(id *)delegate;

@end
