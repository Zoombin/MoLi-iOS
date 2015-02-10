//
//  MLGoods.h
//  MoLi
//
//  Created by zhangbin on 12/10/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"
#import "MLGoodsProperty.h"
#import "MLGoodsIntroduce.h"
#import "MLGoodsIntroduceElement.h"

@interface MLGoods : ZBModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *salesVolume;//总销量
@property (nonatomic, strong) NSNumber *highOpinion;//好评率
@property (nonatomic, strong) NSArray *goodsProperties;
@property (nonatomic, strong) NSString *goodsPropertiesString;
@property (nonatomic, strong) NSArray *gallery;
@property (nonatomic, strong) NSString *choose;
@property (nonatomic, strong) NSArray *multiIntroduce;
@property (nonatomic, strong) NSNumber *marketPrice;
@property (nonatomic, strong) NSNumber *VIPPrice;
@property (nonatomic, strong) NSNumber *favorited;
@property (nonatomic, strong) NSNumber *commentsNumber;
@property (nonatomic, strong, getter=isOnSale) NSNumber *onSale;

//购物车
@property (nonatomic, strong) NSString *displayGoodsPropertiesInCart;
@property (nonatomic, assign) BOOL selectedInCart;
@property (nonatomic, strong) NSNumber *quantityInCart;
@property (nonatomic, strong) NSNumber *hasStorage;

//订单
@property (nonatomic, strong) NSNumber *quantityBought;

//猜你喜欢
@property (nonatomic, strong) NSNumber *voucher;//是否可以使用代金券

+ (NSArray *)handleMultiGoodsWillDeleteOrUpdate:(NSArray *)multiGoods;
- (NSString *)selectedAllProperties;
- (BOOL)voucherValid;
- (NSInteger)linesForMultiIntroduce;
- (NSString *)formattedIntroduce;
- (BOOL)didSelectAllProperties;
- (BOOL)sameGoodsWithSameSelectedProperties:(MLGoods *)goods;

@end
