#import "CalendarRequest.h"
#import "BroadcastDate.h"
#import <YAJL/YAJL.h>

@implementation CalendarRequest

@synthesize delegate;
@synthesize calendarData;

- (id)initWithDelegate:(id)theDelegate {
  if (self = [super init]) {
    self.delegate = theDelegate;
    self.calendarData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:@"http://itrakt.matsimitsu.com/users/calendar.json?name=matsimitsu"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
  }
  NSLog(@"[!] Start download of calendar data");
  return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [calendarData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSMutableArray *dates = [[[NSMutableArray alloc] init] autorelease];
  NSArray *arrayFromData = [calendarData yajl_JSON];
  [calendarData release];

  for(id item in arrayFromData) {
    [dates addObject:[[BroadcastDate alloc] initWithDictionary:item delegate:delegate]];
   }

  NSLog(@"[!] Finished download of calendar data");
  // Let the tableview know we have new dates
  [delegate performSelector:@selector(datesLoaded:) withObject:dates];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"Calendar download failed: %@", [error localizedDescription]);
  [calendarData release];
}

@end
