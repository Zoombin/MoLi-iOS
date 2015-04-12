//
//  MLGoodsCartTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 12/23/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoods.h"
#import "MLCartStore.h"

@protocol MLGoodsCartTableViewCellDelegate <NSObject>

- (void)willSelectGoods:(MLGoods *)goods inCartStore:(MLCartStore *)cartStore;
- (void)willDeselectGoods:(MLGoods *)goods inCartStore:(MLCartStore *)cartStore;
- (void)willDecreaseQuantityOfGoods:(MLGoods *)goods;
- (void)willIncreaseQuantityOfGoods:(MLGoods *)goods;
- (void)didEndEditingGoods:(MLGoods *)goods quantity:(NSInteger)quantity inTextField:(UITextField *)textField;

@end

@interface MLGoodsCartTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MLGoodsCartTableViewCellDelegate> delegate;
@property (nonatomic, strong) MLCartStore *cartStore;
@property (nonatomic, strong) MLGoods *goods;
@property (nonatomic, assign) BOOL editMode;

@end
