//
//  MLStoreDetailsTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 12/19/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLStore.h"

@protocol MLStoreDetailsTableViewCellDelegate <NSObject>

- (void)storeDetailsTableViewCellWillMap:(MLStore *)store;
- (void)storeDetailsTableViewCellWillCall:(MLStore *)store;

@end

@interface MLStoreDetailsTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MLStoreDetailsTableViewCellDelegate> delegate;
@property (nonatomic, strong) MLStore *store;

@end
