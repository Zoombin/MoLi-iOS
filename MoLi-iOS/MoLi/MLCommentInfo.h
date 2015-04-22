//
//  MLCommentInfo.h
//  MoLi
//
//  Created by 颜超 on 15/4/22.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "ZBModel.h"
//        MLGoods *goods = goodsArray[i];
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        dict[@"goodsid"] = goods.ID;
//        dict[@"unique"] = goods.unique;
//        dict[@"content"] = _commentTextView.text;
//        NSMutableArray *imgs = [NSMutableArray array];
//        for (int j = 0; j < [imagePaths count]; j++) {
//            NSDictionary *dict = imagePaths[i];
//            [imgs addObject:dict[@"url"]];
//        }
//        if ([imgs count] > 0) {
//            dict[@"images"] = imgs;
//        }
//        dict[@"stars"] = star;
//        [infoArray addObject:dict];
@interface MLCommentInfo : ZBModel

@property (nonatomic, strong) NSString *goodsid;
@property (nonatomic, strong) NSString *unique;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *imgages;
@property (nonatomic, strong) NSString *stars;
@end
