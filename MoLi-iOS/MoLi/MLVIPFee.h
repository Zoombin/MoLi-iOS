//
//  MLVIPFee.h
//  MoLi
//
//  Created by zhangbin on 1/29/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

@interface MLVIPFee : ZBModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *fee;
@property (nonatomic, strong) NSNumber *duration;

- (BOOL)isTry;
- (BOOL)isYear;
- (BOOL)isMonth;
+ (MLVIPFee *)tryFeeInFees:(NSArray *)fees;
+ (MLVIPFee *)yearFeeInFees:(NSArray *)fees;
+ (MLVIPFee *)monthFeeInFees:(NSArray *)fees;
+ (NSArray *)feesExceptTryInFees:(NSArray *)fees;
+ (NSArray *)validFeesInFees:(NSArray *)fees;

@end
