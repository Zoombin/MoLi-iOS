//
//  UIAlertView+ML.m
//  MoLi
//
//  Created by zhangbin on 4/12/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "UIAlertView+ML.h"

@implementation UIAlertView (ML)

+ (instancetype)enterPaymentPasswordAlertViewWithDelegate:(id<UIAlertViewDelegate>)delegate {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单确认" message:@"请输入支付密码" delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	UITextField *textField = [alert textFieldAtIndex:0];
	textField.secureTextEntry = YES;
	return alert;
}

@end
