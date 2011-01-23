#import <Foundation/Foundation.h>

@interface CalendarRequest : NSObject {
  id delegate;
  id object;
  NSData *calendarData;

}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id object;

@property (nonatomic, retain) NSData *calendarData;

- (id)initWithDelegate:(id *)delegate object:(id *)object;

@end
