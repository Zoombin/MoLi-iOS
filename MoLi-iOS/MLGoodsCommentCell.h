//
//  MLGoodsCommentCell.h
//  MoLi
//
//  Created by LLToo on 15/4/17.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGoodsCommentModel : NSObject

@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSArray *images;

@property (nonatomic,strong) NSString *addContent;   //追加的内容
@property (nonatomic,strong) NSString *addDate;      //追加内容的时间

+ (MLGoodsCommentModel *)modelWithDictionary:(NSDictionary *)dict;

@end


/// 商品评论的cell.
@interface MLGoodsCommentCell : UITableViewCell

@property (nonatomic,assign) float height;

- (void)setShowInfo:(MLGoodsCommentModel *)model;


@end
