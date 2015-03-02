//
//  MLGoodsOrderTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/30/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoodsOrderTableViewCell.h"
#import "Header.h"

@interface MLGoodsOrderTableViewCell() {
    UIImageView *mImageView;
    VerticallyAlignedLabel *mTitleLabel;
    UILabel *mPriceLabel;
    UILabel *mNumberLabel;
}

@end

@implementation MLGoodsOrderTableViewCell



+ (CGFloat)height {
	return 80;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 添加横线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, WINSIZE.width - 20, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self addSubview:line];
        
        mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
        //        mImageView.image = [UIImage imageNamed:@"Placeholder"];
        mImageView.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
        mImageView.layer.borderWidth = 0.5;
        mImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:mImageView];
        
        float x = mImageView.x + mImageView.width + 10;
        float width = WINSIZE.width - x - 20;
        
        mTitleLabel = [[VerticallyAlignedLabel alloc] init];
        [mTitleLabel setVerticalAlignment:VerticalAlignmentTop];
        mTitleLabel.frame = CGRectMake(x, mImageView.frame.origin.y, width, 40);
        mTitleLabel.font = [UIFont systemFontOfSize:16];
        mTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        mTitleLabel.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1];
        mTitleLabel.numberOfLines = 2;
        [self addSubview:mTitleLabel];
        
        mPriceLabel = [[UILabel alloc] init];
        mPriceLabel.frame = CGRectMake(x, mImageView.frame.origin.y + mImageView.frame.size.height - 15, width, 15);
        mPriceLabel.font = [UIFont systemFontOfSize:14];
        mPriceLabel.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
        [self addSubview:mPriceLabel];
        
        mNumberLabel = [[UILabel alloc] init];
        mNumberLabel.frame = CGRectMake(self.frame.size.width - 120, mPriceLabel.frame.origin.y, 100, 15);
        mNumberLabel.font = [UIFont systemFontOfSize:14];
        mNumberLabel.textAlignment = NSTextAlignmentRight;
        mNumberLabel.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
        [self addSubview:mNumberLabel];
        
    }
    return self;
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
    if (_goods) {
        [mImageView setImageWithURL:[NSURL URLWithString:goods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
        mPriceLabel.text = [NSString stringWithFormat:@"价格:¥%0.2f", [_goods.price floatValue]];
        mNumberLabel.text = [NSString stringWithFormat:@"数量:%@", _goods.quantityBought];
        mTitleLabel.text = _goods.name;
	}
}

@end
