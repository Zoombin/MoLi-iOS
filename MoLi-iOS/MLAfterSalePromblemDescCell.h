//
//  MLAfterSalePromblemDescCell.h
//  MoLi
//
//  Created by LLToo on 15/4/14.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 售后描述的cell.
@interface MLAfterSalePromblemDescCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *afterSaleGoodsDetailDict;

+ (CGFloat)height:(BOOL)isBremark;

@end
