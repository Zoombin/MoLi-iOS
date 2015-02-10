//
//  MLShare.h
//  MoLi
//
//  Created by zhangbin on 1/8/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "ZBModel.h"

typedef NS_ENUM(NSUInteger, MLShareObject) {
	MLShareObjectGoods,
	MLShareObjectEStore,
	MLShareObjectFStore,
	MLShareObjectAPP
};

typedef NS_ENUM(NSUInteger, MLSharePlatform) {
	MLSharePlatformWeibo,
	MLSharePlatformQZone,
	MLSharePlatformQQ,
	MLSharePlatformWeChatMessage,
	MLSharePlatformWeChatCircle
};

@interface MLShare : ZBModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *link;

+ (NSString *)identifierForShareObject:(MLShareObject)shareObject;
+ (NSString *)identifierForSHarePlayform:(MLSharePlatform)sharePlatform;
+ (NSDictionary *)parameterWithShareObject:(MLShareObject)shareObject objectID:(id)objectID;

@end
