//
//  MLIdentifyPasswordViewController.h
//  MoLi
//
//  Created by zhangbin on 1/17/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVerifyCode.h"

/// 找密码.
@interface MLIdentifyPasswordViewController : UIViewController

@property (nonatomic, strong) MLVerifyCode *verifyCode;

@end
