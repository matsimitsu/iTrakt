#import "SeasonsEpisodeCell.h"
#import "Checkbox.h"
#import "Episode.h"

@implementation SeasonsEpisodeCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate {
  if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
    checkbox = [[Checkbox alloc] initWithFrame:CGRectMake(7, 7, 28, 28)];
    [checkbox addTarget:delegate action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:checkbox];

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 7, self.bounds.size.width - 42, 28)];
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.numberOfLines = 0;
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
