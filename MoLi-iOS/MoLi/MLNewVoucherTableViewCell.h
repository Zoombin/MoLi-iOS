//
//  MLNewVoucherTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/26/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVoucher.h"

/// 可用代金券的cell.
@interface MLNewVoucherTableViewCell : UITableViewCell

@property (nonatomic, strong) MLVoucher *voucher;

@end
