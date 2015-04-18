//
//  MLGoodsCommentCell.h
//  MoLi
//
//  Created by LLToo on 15/4/17.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 商品评论的cell.
@interface MLGoodsCommentCell : UITableViewCell

@property (nonatomic,assign) float height;

- (void)setShowInfo:(NSDictionary*)dict;

@end
