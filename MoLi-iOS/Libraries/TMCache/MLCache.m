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
        goods.imagePath = dict[@"imagePath"];
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


+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [obj valueForKey:propName];//kvc读值
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}


@end
