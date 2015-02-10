//
//  MLVerifyCode.h
//  MoLi
//
//  Created by zhangbin on 1/17/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

typedef NS_ENUM(NSUInteger, MLVerifyCodeType) {
	MLVerifyCodeTypeSignup,
	MLVerifyCodeTypeForgotPassword,
	MLVerifyCodeTypeForgotWalletPassword
};

@interface MLVerifyCode : ZBModel

@property (nonatomic, assign) MLVerifyCodeType type;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *code;

+ (void)fetchCodeSuccess;
+ (NSInteger)countdown;
+ (NSString *)identifierWithType:(MLVerifyCodeType)type;
- (NSString *)identifier;

@end
