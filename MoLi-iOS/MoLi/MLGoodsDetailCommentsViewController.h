//
//  MLGoodsDetailCommentsViewController.h
//  MoLi
//
//  Created by LLToo on 15/4/16.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MLGoodsCommentType) {
    MLGoodsCommentTypeGood,
    MLGoodsCommentTypeMiddle,
    MLGoodsCommentTypeBad
};


@interface MLGoodsDetailCommentsViewController : UIViewController

@property (nonatomic, strong) MLGoods *goods;

@end
