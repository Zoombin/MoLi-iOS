//
//  MLAfterSaleAddrCell.h
//  MoLi
//
//  Created by LLToo on 15/4/14.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

///添加售后的cell.
@interface MLAfterSaleAddrCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *afterSaleGoodsDetailDict;

+ (CGFloat)height;

@end
