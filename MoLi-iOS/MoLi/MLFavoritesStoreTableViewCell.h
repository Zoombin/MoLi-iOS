//
//  MLFavoritesStoreTableViewCell.h
//  MoLi
//
//  Created by Robin on 15/2/13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 我收藏的店铺cell.
@interface MLFavoritesStoreTableViewCell : UITableViewCell

- (void)updateMLStore:(MLStore *)store;

- (void)updateMLFlagshipStore:(MLFlagshipStore *)store;

@end


