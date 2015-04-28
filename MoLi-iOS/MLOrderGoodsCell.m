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

- (void)setGoods:(MLGoods *)goods {
    _goods = goods;
    if ([goods.service[@"oplist"] count] > 0) {
        int i = 0;
        CGFloat start_X = CGRectGetMinX(self.afterSaleTitleLabel.frame);
        CGFloat start_y = CGRectGetMaxY(self.afterSaleTitleLabel.frame);
        for (NSDictionary *buttonInfo in goods.service[@"oplist"]) {
            NSString *buttonName = buttonInfo[@"name"];
            CGFloat buttonWidth;
            if (buttonName.length<=4) {
                buttonWidth = 80;
            }else{
                buttonWidth = 100;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(start_X + (i * 80) + (15 * i), start_y + 3, buttonWidth, 25)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:buttonName forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithHexString:buttonInfo[@"bgcolor"]]];
            [button setTitleColor:[UIColor colorWithHexString:buttonInfo[@"fontcolor"]] forState:UIControlStateNormal];
            [button.layer setBorderColor:[UIColor colorWithHexString:buttonInfo[@"bordercolor"]].CGColor];
            [button.layer setBorderWidth:.5];
            [button.layer setCornerRadius:4.0];
            [button.layer setMasksToBounds:YES];
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            i ++;
        }
    }
}

- (void)buttonClick:(id)sender {
    NSInteger tag = [sender tag];
    if ([self.delegate respondsToSelector:@selector(buttonClicked:andCode:)]) {
        NSDictionary *buttonInfo = _goods.service[@"oplist"][tag];
        MLOrderOperator *operator = [[MLOrderOperator alloc] initWithAttributes:buttonInfo];
        [self.delegate buttonClicked:_goods andCode:operator];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
