//
//  MLCache.m
//  MoLi
//
//  Created by LLToo on 15/4/9.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLCache.h"
#import "TMCache.h"
#import <objc/runtime.h>

#define MAX_MLGOODS_NUM 10  //保存最大的数量

@implementation MLCache

+ (NSArray *)getCacheMoliGoods
{
    NSArray *array = [[TMCache sharedCache] objectForKey:@"MoLiFootPrint"];
    NSMutableArray *arrayGoods = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in array) {
        MLGoods *goods = [[MLGoods alloc] init];
        goods.ID = dict[@"ID"];
        goods.name = dict[@"name"];
        goods.price = dict[@"price"];
        [arrayGoods addObject:goods];
    }
    
    return arrayGoods;
}

+ (BOOL)hasDataFromMoliGoodsCache
{
    NSMutableArray *array = [[TMCache sharedCache] objectForKey:@"MoLiFootPrint"];
    if(array.count>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)addMoliGoods:(MLGoods *)goods
{
    
    NSMutableArray *array = [[TMCache sharedCache] objectForKey:@"MoLiFootPrint"];
    if (!array) {
        array = [[NSMutableArray alloc] initWithCapacity:MAX_MLGOODS_NUM];
    }

    for (NSDictionary *dict in array) {
        if([dict[@"ID"] isEqualToString:goods.ID])
            return;
    }
    
    if(array.count==MAX_MLGOODS_NUM) {
        //如果满10个将第一个移除
        [array removeObjectAtIndex:0];
    }
   
    NSDictionary *dict = [self getObjectData:goods];
    [array addObject:dict];
    
    [[TMCache sharedCache] setObject:array forKey:@"MoLiFootPrint"];
}

+ (void)clearAllMoliGoodsData
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:MAX_MLGOODS_NUM];
    [[TMCache sharedCache] setObject:array forKey:@"MoLiFootPrint"];
}


@end
