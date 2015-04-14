//
//  MLOrderGoodsCell.h
//  MoLi
//
//  Created by 颜超 on 15/4/13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGoods.h"

@protocol MLOrderGoodsCellDelegate <NSObject>
- (void)cancelAfterSale:(MLGoods *)goods;
- (void)applyAfterSale:(MLGoods *)goods;
@end

@interface MLOrderGoodsCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *dashLine;
@property (nonatomic, weak) IBOutlet UILabel *storeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *afterSaleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) MLGoods *goods;
@property (nonatomic, weak) id<MLOrderGoodsCellDelegate> delegate;
- (IBAction)applyButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@end
