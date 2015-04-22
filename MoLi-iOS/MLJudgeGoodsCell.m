//
//  MLJudgeGoodsCellTableViewCell.m
//  MoLi
//
//  Created by yc on 15-4-22.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLJudgeGoodsCell.h"

@implementation MLJudgeGoodsCell

- (void)awakeFromNib {
    // Initialization code
    _iconImageView.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    _iconImageView.layer.borderWidth = 0.5;
    
    _commentTextView.backgroundColor = [UIColor backgroundColor];
    _commentTextView.delegate = self;
    [_commentTextView.layer setCornerRadius:4.0];
    [_commentTextView.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
