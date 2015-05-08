//
//  MLMessage.h
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 消息信息.
@interface MLMessage : ZBModel

@property (nonatomic, strong) NSNumber *isRead;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSNumber *sendTimestamp;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *username;
- (NSString *)displaySendDate;

@end
