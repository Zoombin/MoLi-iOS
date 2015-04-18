//
//  MLAdvertisementElement.h
//  MoLi
//
//  Created by zhangbin on 1/8/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

/// 广告信息element.
@interface MLAdvertisementElement : ZBModel

@property (nonatomic, strong) NSString *pageCode;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *parameterID;
@property (nonatomic, strong) NSString *redirectType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *URLString;

- (BOOL)isOpenWebView;
- (Class)classOfRedirect;

@end
