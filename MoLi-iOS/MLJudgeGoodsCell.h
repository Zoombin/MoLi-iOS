//
//  MLJudgeGoodsCellTableViewCell.h
//  MoLi
//
//  Created by yc on 15-4-22.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 订单评价的cell.
@interface MLJudgeGoodsCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *goodsNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *numLabel;
@property (nonatomic, weak) IBOutlet UITextView *commentTextView;
@end
