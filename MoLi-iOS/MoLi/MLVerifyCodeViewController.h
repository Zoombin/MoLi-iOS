//
//  MLVerifyCodeViewController.h
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVerifyCode.h"

/// 找回密码或者交易密码.
@interface MLVerifyCodeViewController : UIViewController

@property (nonatomic, assign) MLVerifyCodeType type;

@end
