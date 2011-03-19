#import "SeasonsEpisodeCell.h"
#import "Checkbox.h"
#import "Episode.h"

@implementation SeasonsEpisodeCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate {
  if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    CGFloat x = 8;
    CGFloat width = 28;
    checkbox = [[Checkbox alloc] initWithFrame:CGRectMake(x, 11, width, width)];
    [checkbox addTarget:delegate action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:checkbox];

    x += width;
    CGFloat accessoryViewWidth = 20;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 8, self.bounds.size.width - x - accessoryViewWidth, width)];
    titleLabel.minimumFontSize = [UIFont systemFontSize];
    titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    [self.contentView addSubview:titleLabel];
  }
  return self;
}


- (void)updateCellWithEpisode:(Episode *)episode {
  [checkbox setSelected:episode.seen withAnimation:NO];
  titleLabel.text = episode.title;
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    //[super setSelected:selected animated:animated];
    
    //// Configure the view for the selected state.
//}


- (void)dealloc {
  [checkbox release];
  [titleLabel release];
  [super dealloc];
}


@end
