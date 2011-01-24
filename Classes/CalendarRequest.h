#import <Foundation/Foundation.h>

@interface CalendarRequest : NSObject {
  id delegate;
  NSMutableData *calendarData;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSData *calendarData;

- (id)initWithDelegate:(id)theDelegate;

@end
