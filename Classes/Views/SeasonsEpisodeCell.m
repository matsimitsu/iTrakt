#import "SeasonsEpisodeCell.h"
#import "Checkbox.h"

@implementation SeasonsEpisodeCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate disclosureAccessory:(BOOL)flag {
  if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
    if (flag) {
      self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    CGFloat x = 8;
    CGFloat width = 28;
    checkbox = [[Checkbox alloc] initWithFrame:CGRectMake(x, 11, width, width)];
    [checkbox addTarget:delegate action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:checkbox];

    x += width;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 8, self.bounds.size.width - x - (2 * self.indentationWidth), width)];
    titleLabel.minimumFontSize = [UIFont systemFontSize];
    titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    [self.contentView addSubview:titleLabel];
  }
  return self;
}


- (void)setSelected:(BOOL)selected text:(NSString *)text {
  [checkbox setSelected:selected withAnimation:NO];
  titleLabel.text = text;
}


- (void)dealloc {
  [checkbox release];
  [titleLabel release];
  [super dealloc];
}


@end
