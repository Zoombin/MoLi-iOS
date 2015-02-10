//
//  MLResponse.h
//  MoLi
//
//  Created by zhangbin on 1/24/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLResponse : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDictionary *data;

- (instancetype)initWithResponseObject:(id)responseObject;

@end
