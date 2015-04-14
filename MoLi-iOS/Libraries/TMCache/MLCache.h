//
//  MLCache.h
//  MoLi
//
//  Created by LLToo on 15/4/9.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//  为MoLi提供Cache接口

#import <Foundation/Foundation.h>
#import "MLGoods.h"

@interface MLCache : NSObject

+ (NSArray *)getCacheMoliGoods;

// 是否有保存的足迹数据
+ (BOOL)hasDataFromMoliGoodsCache;

// 新增浏览的物品
+ (void)addMoliGoods:(MLGoods *)goods;

// 清空所有足迹数据
+ (void)clearAllMoliGoodsData;

+ (BOOL)isNullObject:(id)obj;

@end
