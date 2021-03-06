//
//  ZBPaymentManager.h
//  dushuhu
//
//  Created by zhangbin on 8/30/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLWeixinPaymentParameters.h"

//Weixin
#import	"WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"

//Alipay
//#import "AlixPayOrder.h"
#import "Order.h"
//#import "AlixLibService.h"
//#import "PartnerConfig.h"
#import "DataSigner.h"
//#import "AlixPayResult.h"
#import "DataVerifier.h"

#define WEIXIN_APP_ID @"wx501bd7cea77cc83a"//TODO: moli
//#define WEIXIN_OPEN_ID @"gh_463031496f61"//TODO: yo
#define ALIPAY_SCHEME @"AlipaySdkDemo"

#define ZBPaymentKeySuccess @"PaymentKeySuccess"
#define ZBPaymentKeyType @"PaymentKeyType"
#define ZBPaymentKeyAlipayMobile @"PaymentKeyAlipayMobile"

#define ZBPAYMENT_NOTIFICATION_AFTER_PAY_IDENTIFIER @"ZBPAYMENT_NOTIFICATION_AFTER_PAY_IDENTIFIER"

typedef NS_ENUM(NSInteger, ZBPaymentType) {
	ZBPaymentTypeWeixin,
	ZBPaymentTypeAlipay,
	ZBPaymentTypeCount
};

/// ZBPaymentManager 支付管理.
@interface ZBPaymentManager : NSObject

+ (instancetype)shared;
- (void)weixinPayPrice:(NSString *)price orderID:(NSString *)orderID partnerID:(NSString *)partnerID appID:(NSString *)appID appKey:(NSString *)appKey prepayID:(NSString *)prepayID nonceString:(NSString *)nonceString timestampString:(NSString *)timestampString package:(NSString *)package sign:(NSString *)sign;

- (void)pay:(ZBPaymentType)type price:(NSString *)price orderID:(NSString *)orderID name:(NSString *)name description:(NSString *)description callbackURLString:(NSString *)callbackURLString withBlock:(void (^)(BOOL success))block;

- (void)afterPay:(ZBPaymentType)type withURL:(NSURL *)url;

@end
