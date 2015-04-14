//
//  MLGoodsIntroduceCollectionViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/10/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCommonCollectionViewCell.h"
#import "MLGoods.h"

@interface MLGoodsIntroduceCollectionViewCell : MLCommonCollectionViewCell

@property (nonatomic, strong) UIImageView *imageViews;

+ (CGFloat)heightPerIntroduceElementLine;

@end
