//
//  MLAddressTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/13/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLAddress.h"

@protocol MLAddressTableViewCellDelegate <NSObject>

@optional
- (void)setDefaultAddress:(MLAddress *)address;

@end

/// address的cell.
@interface MLAddressTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MLAddressTableViewCellDelegate> delegate;
@property (nonatomic, strong) MLAddress *address;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL editOrderMode;//填写订单时候展示

- (void)setAfterSaleCellState:(MLAfterSalesType)type;  //设置申请售后cell样式

@end
