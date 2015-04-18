//
//  MLAfterSaleGoodsDetailCell.h
//  MoLi
//
//  Created by LLToo on 15/4/11.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 售后的详情cell.
@interface MLAfterSaleGoodsDetailCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *afterSaleGoodsDetailDict;

+ (CGFloat)height:(MLAfterSalesType)type;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(MLAfterSalesType)type;

@end
