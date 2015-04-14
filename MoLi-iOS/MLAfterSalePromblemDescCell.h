//
//  MLAfterSalePromblemDescCell.h
//  MoLi
//
//  Created by LLToo on 15/4/14.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLAfterSalePromblemDescCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *afterSaleGoodsDetailDict;

+ (CGFloat)height:(BOOL)isBremark;

@end
