//
//  MLOrderAddressCell.m
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLOrderAddressCell.h"
#import "UIView+Utils.h"
@implementation MLOrderAddressCell

- (void)awakeFromNib {
    // Initialization code
    [_dashLine dottedLine:[UIColor lightGrayColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)logisticButtonClicked:(id)sender {
    NSLog(@"点击物流按钮...");
    if ([self.delegate respondsToSelector:@selector(showLogisticInfo:)]) {
        MLOrderOperator *orderOperator = [[MLOrderOperator alloc] init];
        orderOperator.type = MLOrderOperatorTypeLogistic;
        [self.delegate showLogisticInfo:orderOperator];
    }
}

@end
