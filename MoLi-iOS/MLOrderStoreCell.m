//
//  MLOrderStoreCell.m
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLOrderStoreCell.h"

@implementation MLOrderStoreCell

- (void)awakeFromNib {
    // Initialization code
    [_detailButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_detailButton.layer setBorderWidth:.5];
    
    [_phoneButton.layer setCornerRadius:4.0];
    [_phoneButton.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)storeDetailButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showStoreDetail)]) {
        [self.delegate showStoreDetail];
    }
}

- (IBAction)phoneButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(phoneButtonClick)]) {
        [self.delegate phoneButtonClick];
    }
}
@end
