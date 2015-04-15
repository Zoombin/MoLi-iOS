//
//  UIViewController+MLShare.h
//  MoLi
//
//  Created by zhangbin on 4/15/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"
#import "MLShare.h"

@interface UIViewController (MLShare) <UMSocialUIDelegate, UMSocialDataDelegate>

- (void)socialShare:(MLShareObject)shareObject objectID:(NSString *)objectID;

@end
