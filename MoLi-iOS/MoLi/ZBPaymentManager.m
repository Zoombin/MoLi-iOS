//
//  ZBPaymentManager.m
//  dushuhu
//
//  Created by zhangbin on 8/30/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBPaymentManager.h"

@interface ZBPaymentManager () <AlixPaylibDelegate, WXApiDelegate>

@end

@implementation ZBPaymentManager

+ (instancetype)shared {
	static ZBPaymentManager *_shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_shared = [[ZBPaymentManager alloc] init];
	});
	return _shared;
}

- (void)pay:(ZBPaymentType)type price:(NSString *)price orderID:(NSString *)orderID name:(NSString *)name description:(NSString *)description callbackURLString:(NSString *)callbackURLString withBlock:(void (^)(BOOL success))block {
	if (type == ZBPaymentTypeAlipay) {
		[self alipayByOrderID:orderID price:price name:name description:description callbackURLString:callbackURLString];
		if (block) block (YES);
	} else if (type == ZBPaymentTypeWeixin) {
		[self weixinpayPrice:price orderID:orderID withBlock:^(BOOL success) {
			if (block) block(success);
		}];
	} else {
		if (block) block(YES);
	}
}

- (void)afterPay:(ZBPaymentType)type withURL:(NSURL *)url {
	if (type == ZBPaymentTypeAlipay) {
		NSString *result = url.query;
		[self checkAlipayResult:result isReturnFromAlipayMobile:YES];
	} else if (type == ZBPaymentTypeWeixin) {
		[WXApi handleOpenURL:url delegate:self];
	}
}

#pragma mark - Alipay

- (void)alipayByOrderID:(NSString *)orderID price:(NSString *)price name:(NSString *)name description:(NSString *)description callbackURLString:(NSString *)callbackURLString {
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = PartnerID;
	order.seller = SellerID;
	order.tradeNO = orderID;//订单ID（由商家自行制定）
	order.productName = name ?: @"订单名称";
	order.productDescription = description ?: @"订单描述";
	order.amount = price;
	order.notifyURL = callbackURLString;
	NSString *orderInfo = [order description];
	NSString *signedStr = [[ZBPaymentManager shared] doRsa:orderInfo];
	NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderInfo, signedStr, @"RSA"];
	[AlixLibService payOrder:orderString AndScheme:ALIPAY_SCHEME seletor:@selector(paymentResultDelegate:) target:self];
}

-(NSString *)doRsa:(NSString *)orderInfo {
	id<DataSigner> signer;
	signer = CreateRSADataSigner(PartnerPrivKey);
	NSString *signedString = [signer signString:orderInfo];
	return signedString;
}

//Alipay回调函数,应用内打开支付宝页面返回后回调的
- (void)paymentResultDelegate:(NSString *)result {
	[self checkAlipayResult:result isReturnFromAlipayMobile:NO];
}

- (void)checkAlipayResult:(NSString *)result isReturnFromAlipayMobile:(BOOL)alipayMobile {
	BOOL success = NO;
	NSString *resultStatus = @"ResultStatus";
	NSRange statusRange = [result.lowercaseString rangeOfString:resultStatus.lowercaseString];
	NSString *code = @"9000";
	NSRange codeRange = [result.lowercaseString rangeOfString:code];
	if (statusRange.location != NSNotFound && codeRange.location != NSNotFound) {
		NSInteger delta = codeRange.location - statusRange.location;
		if (delta > 0 && delta < 30) {
			success = YES;
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ZBPAYMENT_NOTIFICATION_AFTER_PAY_IDENTIFIER object:nil userInfo:@{ZBPaymentKeySuccess : @(success), ZBPaymentKeyType : @(ZBPaymentTypeAlipay), ZBPaymentKeyAlipayMobile : @(alipayMobile)}];
}

#pragma mark - Weixinpay

- (void)weixinPayPrice:(NSString *)price orderID:(NSString *)orderID partnerID:(NSString *)partnerID appID:(NSString *)appID appKey:(NSString *)appKey prepayID:(NSString *)prepayID nonceString:(NSString *)nonceString timestampString:(NSString *)timestampString package:(NSString *)package sign:(NSString *)sign {
	//调起微信支付
	PayReq *req = [[PayReq alloc] init];
	req.openID = appID;
	req.partnerId = partnerID;
	req.prepayId = prepayID;
	req.nonceStr = nonceString;
	NSLog(@"timestamp string: %@", timestampString);
	req.timeStamp = [timestampString integerValue];
	NSLog(@"timestamp: %@", @([timestampString integerValue]));
	req.package = package;
	req.sign = sign;
	[WXApi safeSendReq:req];
}

- (void)weixinpayPrice:(NSString *)price orderID:(NSString *)orderID withBlock:(void (^)(BOOL success))block; {
	NSString *PARTNER_ID = @"1219110101";
	NSString *PARTNER_KEY = @"0b8bef3f858cb1bfc8d3d321774ce6d7";
	NSString *APPI_ID = WEIXIN_APP_ID;
	NSString *APP_SECRET = @"27a4cc2ce3f0f6e1bc4040254c5cc6f1";
	NSString *APP_KEY = @"FFbpJVbzGhlsoSr9eRF88S9hCBHf2aSIt9gN3HOvExPdoKgxh8AZqcy4yzBk37bTdcBTbwsH5xEpn6kCm8ezucIjbwCYJhE51LhiCqHizkuNp4cyHr1eYcl31GKYqzGG";
#warning TODO
	NSString *baseURLString = @"http://222.92.197.77/cashier/appNotify.htm";
	NSString *NOTIFY_URL = [NSString stringWithFormat:@"%@weixin/weixinapppay/weixinapppay_notify.php?order_id=%@", baseURLString, orderID];
	
	NSLog(@"notify_url: %@", NOTIFY_URL);
	NSMutableString *ORDER_NAME = [NSMutableString string];
	[ORDER_NAME appendString:NSLocalizedString(@"iOS", nil)];
	[ORDER_NAME appendString:@"_"];
	[ORDER_NAME appendString:orderID];
	
	//创建支付签名对象
	payRequsestHandler *req = [[payRequsestHandler alloc] init];
	[req init:APPI_ID app_secret:APP_SECRET partner_key:PARTNER_KEY app_key:APP_KEY];
	time_t now;
	time(&now);
	NSString *Token = [req GetToken];
	NSLog(@"获取Token： %@\n",[req getDebugifo]);
	if (Token != nil){
		//================================
		//预付单参数订单设置
		//================================
		NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
		[packageParams setObject:@"WX" forKey:@"bank_type"];
		[packageParams setObject:ORDER_NAME forKey:@"body"];
		[packageParams setObject:@"1" forKey:@"fee_type"];
		[packageParams setObject:@"UTF-8" forKey:@"input_charset"];
		[packageParams setObject:NOTIFY_URL forKey:@"notify_url"];
		[packageParams setObject:orderID forKey:@"out_trade_no"];
		[packageParams setObject:PARTNER_ID forKey:@"partner"];
		[packageParams setObject:@"196.168.1.1" forKey:@"spbill_create_ip"];
		[packageParams setObject:price forKey:@"total_fee"];
		
		NSString *package, *time_stamp, *nonce_str, *traceid;
		package = [req genPackage:packageParams];
		NSString *debug = [req getDebugifo];
		NSLog(@"gen package: %@\n",package);
		NSLog(@"生成package: %@\n",debug);
		
		//设置支付参数
		time_stamp = [NSString stringWithFormat:@"%ld", now];
		nonce_str = [TenpayUtil md5:time_stamp];
		traceid = WEIXIN_OPEN_ID;
		NSMutableDictionary *prePayParams = [NSMutableDictionary dictionary];
		[prePayParams setObject:APPI_ID forKey:@"appid"];
		[prePayParams setObject:APP_KEY forKey:@"appkey"];
		[prePayParams setObject:nonce_str forKey:@"noncestr"];
		[prePayParams setObject:package forKey:@"package"];
		[prePayParams setObject:time_stamp forKey:@"timestamp"];
		[prePayParams setObject:traceid forKey:@"traceid"];
		
		//生成支付签名
		NSString *sign;
		sign = [req createSHA1Sign:prePayParams];
		//增加非参与签名的额外参数
		[prePayParams setObject:@"sha1" forKey:@"sign_method"];
		[prePayParams setObject:sign forKey:@"app_signature"];
		
		NSString *prePayid;
		prePayid = [req sendPrepay:prePayParams];
		debug = [req getDebugifo];
		NSLog(@"提交预付单： %@\n",debug);
		
		if (prePayid != nil) {
			//重新按提交格式组包，微信客户端5.0.3以前版本只支持package=Sign=***格式，须考虑升级后支持携带package具体参数的情况
			//package       = [NSString stringWithFormat:@"Sign=%@",package];
			package         = @"Sign=WXPay";
			//签名参数列表
			NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
			[signParams setObject: APPI_ID forKey:@"appid"];
			[signParams setObject: APP_KEY forKey:@"appkey"];
			[signParams setObject: nonce_str forKey:@"noncestr"];
			[signParams setObject: package forKey:@"package"];
			[signParams setObject: PARTNER_ID forKey:@"partnerid"];
			[signParams setObject: time_stamp forKey:@"timestamp"];
			[signParams setObject: prePayid forKey:@"prepayid"];
			//生成签名
			sign = [req createSHA1Sign:signParams];
			debug = [req getDebugifo];
			NSLog(@"调起支付签名： %@\n",debug);
			
			//调起微信支付
			PayReq *req = [[PayReq alloc] init];
			req.openID = APPI_ID;
			req.partnerId = PARTNER_ID;
			req.prepayId = prePayid;
			req.nonceStr = nonce_str;
			req.timeStamp = now;
			req.package = package;
			req.sign = sign;
			[WXApi safeSendReq:req];
		} else {
			NSLog(@"获取prepayid失败\n");
			if (block) block(NO);
		}
	} else {
		NSLog(@"获取Token失败\n");
		if (block) block (NO);
	}
	if (block) block (YES);
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
	if([resp isKindOfClass:[PayResp class]]) {//只处理支付的回调
		BOOL success = NO;
		if (resp.errCode == WXSuccess) {
			NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
			success = YES;
		} else {
			NSLog(@"Wrong，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
		}
		//[[NSNotificationCenter defaultCenter] postNotificationName:DSH_NOTIFICATION_AFTER_PAY_IDENTIFIER object:nil userInfo:@{PaymentKeySuccess : @(success), PaymentKeyType : @(ZBPaymentTypeWeixin)}];
	}
}

@end
