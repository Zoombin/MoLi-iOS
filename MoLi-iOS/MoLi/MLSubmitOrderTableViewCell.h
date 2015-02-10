//
//  MLSubmitOrderTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLSubmitOrderTableViewCellDelegate <NSObject>

- (void)submitOrder;

@end

@interface MLSubmitOrderTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MLSubmitOrderTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSNumber *price;

@end
