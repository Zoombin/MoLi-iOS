//
//  MLAfterSaleGoodsDetailCell.m
//  MoLi
//
//  Created by LLToo on 15/4/11.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLAfterSaleGoodsDetailCell.h"

@interface MLAfterSaleGoodsDetailCell ()

@property (nonatomic,weak) IBOutlet UILabel *lblGoodsName;      //商品名
@property (nonatomic,weak) IBOutlet UILabel *lblGoodsType;      //售后类型
@property (nonatomic,weak) IBOutlet UILabel *lblGoodsState;     //售后状态
@property (nonatomic,weak) IBOutlet UILabel *lblGoodsTime;      //申请时间

@end

@implementation MLAfterSaleGoodsDetailCell

+ (CGFloat)height {
    return 115;
}




@end
