//
//  MLUseVoucherTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVoucher.h"

/// 使用了的代金券cell.
@protocol MLUseVoucherTableViewCellDelegate <NSObject>

- (void)willingUseVoucherValue:(NSNumber *)value inTextField:(UITextField *)textField;
- (void)selectedUseVoucher:(BOOL)selected;

@end

@interface MLUseVoucherTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MLUseVoucherTableViewCellDelegate> delegate;
@property (nonatomic, strong) MLVoucher *voucher;
@property (nonatomic, assign) BOOL selectedVoucher;

@end
