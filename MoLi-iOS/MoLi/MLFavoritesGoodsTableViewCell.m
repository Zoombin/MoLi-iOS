//
//  MLFavoritesGoodsTableViewCell.m
//  MoLi
//
//  Created by Robin on 15/2/13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLFavoritesGoodsTableViewCell.h"

@interface MLFavoritesGoodsTableViewCell() {
    UIImageView *mImageView;
    VerticallyAlignedLabel *mTitleLabel;
    UILabel *mPriceLabel;
}

@end

@implementation MLFavoritesGoodsTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
        mImageView.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
        mImageView.layer.borderWidth = 0.5;
        mImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:mImageView];
        
        float x = mImageView.x + mImageView.width + 10;
        float width = WINSIZE.width - x - 20;
        
        mTitleLabel = [[VerticallyAlignedLabel alloc] init];
        [mTitleLabel setVerticalAlignment:VerticalAlignmentTop];
        mTitleLabel.frame = CGRectMake(x, 10, width, 40);
        mTitleLabel.font = [UIFont systemFontOfSize:16];
        mTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        mTitleLabel.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1];
        mTitleLabel.numberOfLines = 2;
        [self addSubview:mTitleLabel];
        
        mPriceLabel = [[UILabel alloc] init];
        mPriceLabel.frame = CGRectMake(x, mTitleLabel.y + mTitleLabel.height, width, 15);
        mPriceLabel.font = [UIFont systemFontOfSize:14];
        mPriceLabel.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
        [self addSubview:mPriceLabel];

    }
    return self;
}

- (void)updateValue:(MLGoods *)goods {
    [mImageView setImageWithURL:[NSURL URLWithString:goods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    mPriceLabel.text = [NSString stringWithFormat:@"价格:￥%.2f", goods.price.floatValue];
    mTitleLabel.text = goods.name;
    
}

@end
