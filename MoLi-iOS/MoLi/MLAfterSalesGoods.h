//
//  MLAfterSalesGoods.h
//  MoLi
//
//  Created by zhangbin on 2/1/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"
#import "MLOrderOperator.h"

typedef NS_ENUM(NSUInteger, MLAfterSalesType) {
	MLAfterSalesTypeUnknow,
	MLAfterSalesTypeReturn,
	MLAfterSalesTypeChange
};

@interface MLAfterSalesGoods : ZBModel

@property (nonatomic, strong) NSString *orderNO;
@property (nonatomic, strong) NSString *tradeID;
@property (nonatomic, strong) NSString *goodsID;
@property (nonatomic, strong) NSString *unique;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSString *typeString;
@property (nonatomic, assign) MLAfterSalesType type;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSArray *orderOperators;

@end
