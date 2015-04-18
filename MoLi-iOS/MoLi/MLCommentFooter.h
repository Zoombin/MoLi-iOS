//
//  MLCommentFooter.h
//  MoLi
//
//  Created by zhangbin on 2/1/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCartStore.h"

/// 评论的footer.
@interface MLCommentFooter : UIView

@property (nonatomic, strong) MLCartStore *cartStore;

+ (CGFloat)height;

@end
