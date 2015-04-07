//
//  MLVoucherTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVoucher.h"

@interface MLVoucherTableViewCell : UITableViewCell

@property (nonatomic, strong) MLVoucher *voucher;
@property (nonatomic) BOOL isVoucherDetail;      //YES:显示使用细则 NO:显示代金券

/* 根据isVoucherDetail展示不同的文案 */
- (void)showDetail;


@end
