//
//  MLStoreCommentTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 12/19/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLStoreComment.h"

/// 实体店评论cell.
@interface MLStoreCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) MLStoreComment *storeComment;

@end
