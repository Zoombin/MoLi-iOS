//
//  MLFavoritesStoreTableViewCell.m
//  MoLi
//
//  Created by Robin on 15/2/13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLFavoritesStoreTableViewCell.h"

@interface MLFavoritesStoreTableViewCell() {
    UIImageView *mImageView;
    UILabel *mTitleLabel;
}

@end


@implementation MLFavoritesStoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 40)];
        //        mImageView.image = [UIImage imageNamed:@"Placeholder"];
        mImageView.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
        mImageView.layer.borderWidth = 0.5;
        mImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:mImageView];
        
        float x = mImageView.x + mImageView.width + 10;
        float width = WINSIZE.width - x - 20;
        
        mTitleLabel = [[VerticallyAlignedLabel alloc] init];
        mTitleLabel.frame = CGRectMake(x, 10, width, 40);
        mTitleLabel.font = [UIFont systemFontOfSize:16];
        mTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        mTitleLabel.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1];
        mTitleLabel.numberOfLines = 2;
        [self addSubview:mTitleLabel];
    }
    return self;
}

- (void)updateMLStore:(MLStore *)store {
    [mImageView setImageWithURL:[NSURL URLWithString:store.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    mTitleLabel.text = store.name;
}

- (void)updateMLFlagshipStore:(MLFlagshipStore *)store {
    [mImageView setImageWithURL:[NSURL URLWithString:store.iconPath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    mTitleLabel.text = store.name;
}
@end
