//
//  MLUseVoucherTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVoucher.h"

@interface MLUseVoucherTableViewCell : UITableViewCell

@property (nonatomic, strong) MLVoucher *voucher;
@property (nonatomic, assign) BOOL selectedVoucher;

@end
