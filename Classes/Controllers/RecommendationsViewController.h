#import <UIKit/UIKit.h>
#import "ImageRootController.h"

@interface RecommendationsViewController : ImageRootController {
  NSArray *recommendations;
}

@property (nonatomic, retain) NSArray *recommendations;

@end
