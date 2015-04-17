//
//  MLOrderGoodsCell.m
//  MoLi
//
//  Created by 颜超 on 15/4/13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLOrderGoodsCell.h"
#import "UIView+Utils.h"

@implementation MLOrderGoodsCell

- (void)awakeFromNib {
    [_dashLine dottedLine:[UIColor lightGrayColor]];
    
    _photoImageView.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    _photoImageView.layer.borderWidth = 0.5;
}

- (IBAction)applyButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(applyAfterSale:)]) {
        [self.delegate applyAfterSale:_goods];
    }
}

- (IBAction)cancelButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelAfterSale:)]) {
        [self.delegate cancelAfterSale:_goods];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
