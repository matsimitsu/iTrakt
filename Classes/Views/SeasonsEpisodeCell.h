#import <UIKit/UIKit.h>

@class Checkbox;
@class Episode;

@interface SeasonsEpisodeCell : UITableViewCell {
  Checkbox *checkbox;
  UILabel *titleLabel;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate;
- (void)updateCellWithEpisode:(Episode *)episode;

@end
