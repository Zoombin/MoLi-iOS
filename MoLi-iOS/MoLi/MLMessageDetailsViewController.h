//
//  MLMessageDetailsViewController.h
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLMessage.h"

/// 消息详情.
@interface MLMessageDetailsViewController : UIViewController

@property (nonatomic, strong) MLMessage *message;

@end
