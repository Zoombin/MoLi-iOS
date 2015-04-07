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

- (void)setDefaultAddress:(MLAddress *)address;

@end

@interface MLAddressTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MLAddressTableViewCellDelegate> delegate;
@property (nonatomic, strong) MLAddress *address;
@property (nonatomic, strong) NSIndexPath *indexPath;

/* 已默认地址设置UI */
- (void)setDefaultAddressCellState;

@end
