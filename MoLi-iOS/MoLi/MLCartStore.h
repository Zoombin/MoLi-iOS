//
//  MLCartStore.h
//  MoLi
//
//  Created by zhangbin on 12/23/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLCartStore : ZBModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *multiGoods;
@property (nonatomic, assign) BOOL selectedInCart;
@property (nonatomic, strong) NSString *commentWillSend;
@property (nonatomic, strong) NSString *shippingName;
@property (nonatomic, strong) NSNumber *shippingFee;
@property (nonatomic, strong) NSNumber *numberOfGoods;
@property (nonatomic, strong) NSNumber *totalPrice;

+ (NSArray *)handleCartStoresForSaveOrder:(NSArray *)cartStores;

@end
