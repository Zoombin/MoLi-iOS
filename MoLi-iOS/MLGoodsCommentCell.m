//
//  MLGoodsCommentCell.m
//  MoLi
//
//  Created by LLToo on 15/4/17.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLGoodsCommentCell.h"
#import "UIImageView+AFNetworking.h"
#import "MLCache.h"

@implementation MLGoodsCommentModel

+ (MLGoodsCommentModel *)modelWithDictionary:(NSDictionary *)dict
{
    MLGoodsCommentModel *model = [[MLGoodsCommentModel alloc] init];
    model.content = dict[@"content"];
    model.desc = dict[@"spec"];
    model.images = dict[@"images"];
    model.username = dict[@"username"];
    model.date = dict[@"senddate"];
    model.addContent = dict[@"addcontent"];
    model.addDate = dict[@"adddate"];
    return model;
}

@end


@interface MLGoodsCommentCell()

@property (nonatomic,strong) UILabel *lblComment;
@property (nonatomic,strong) MLGoodsCommentModel *model;

@end

@implementation MLGoodsCommentCell

+ (CGFloat)height
{
    return 200;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setShowInfo:(MLGoodsCommentModel *)model
{
    self.model = model;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 15, 0, 15);
    
    CGRect rect = CGRectZero;
    rect.origin.x = edgeInsets.left;
    rect.origin.y = edgeInsets.top;
    rect.size.width = WINSIZE.width - edgeInsets.left - edgeInsets.right;
    rect.size.height = 30;
    
    self.lblComment = [[UILabel alloc] initWithFrame:rect];
    self.lblComment.font = [UIFont systemFontOfSize:14];
    self.lblComment.textColor = [UIColor blackColor];
    self.lblComment.backgroundColor = [UIColor clearColor];
    self.lblComment.text = model.content;
    [self.contentView addSubview:self.lblComment];
    
    rect.origin.y += 30;
    
    NSArray *images = model.images;
    if (images.count>0) {
        for (int i =0; i<images.count; i++) {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x+60*i, rect.origin.y, 50, 50)];
            imgview.layer.masksToBounds = YES;
            imgview.layer.cornerRadius = 4;
            [imgview setImageWithURL:[NSURL URLWithString:[images objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
            [self.contentView addSubview:imgview];
            
            UIControl *imgControl = [[UIControl alloc] initWithFrame:imgview.frame];
            imgControl.backgroundColor = [UIColor clearColor];
            imgControl.tag = i;
            [imgControl addTarget:self action:@selector(didPressedImageControl:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:imgControl];
            
        }
        rect.origin.y+= 55;
    }
    
    rect.origin.x = edgeInsets.left;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.textColor = [UIColor fontGrayColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = model.desc;
    [self.contentView addSubview:lbl];
    
    rect.origin.y += 30;
    rect.size.width = WINSIZE.width/2.0;
    lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.textColor = [UIColor fontGrayColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = model.username;
    [self.contentView addSubview:lbl];
    
    rect.origin.x = WINSIZE.width/2.0;
    rect.size.width = WINSIZE.width/2.0-15;
    lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.textColor = [UIColor fontGrayColor];
    lbl.textAlignment = NSTextAlignmentRight;
    lbl.text = model.date;
    [self.contentView addSubview:lbl];
    
    
    //添加追加内容
    if (![MLCache isNullObject:model.addContent]&&![model.addContent isEqualToString:@""]) {
        rect.origin.y += 30;
        rect.origin.x = edgeInsets.left;
        rect.size.width = WINSIZE.width-30;
        UIView *addView = [[UIView alloc] initWithFrame:rect];
        addView.backgroundColor = [UIColor clearColor];
        
        UIImageView *arrowImgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowUp"]];
        arrowImgview.center = CGPointMake(40, arrowImgview.frame.size.height/2.0);
        [addView addSubview:arrowImgview];
        
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, arrowImgview.frame.size.height, rect.size.width, rect.size.height-arrowImgview.frame.size.height)];
        grayView.backgroundColor = UIColorFromRGB(0xdcdcdc);
        [addView addSubview:grayView];
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, arrowImgview.frame.size.height, rect.size.width-10, rect.size.height-arrowImgview.frame.size.height)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = [UIFont systemFontOfSize:13];
        lbl.textColor = [UIColor fontGrayColor];
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.text = model.addContent;
        CGSize size = [lbl boundingRectWithSize:CGSizeMake(rect.size.width-10, 30)];
        lbl.frame = CGRectMake(5, arrowImgview.frame.size.height, size.width, size.height+5);
        grayView.frame = CGRectMake(0, arrowImgview.frame.size.height, rect.size.width, size.height+5);
        [addView addSubview:lbl];
        
        rect.size.height = arrowImgview.frame.size.height+grayView.frame.size.height;
        addView.frame = rect;
        [self.contentView addSubview:addView];
    }
    
    rect.origin.y += rect.size.height+15;
    rect.origin.x = edgeInsets.left;
    rect.size.width = WINSIZE.width-15;
    rect.size.height = 0.5;
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:rect];
    [lineView dottedLine:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1]];
    [self addSubview:lineView];
    
    self.height = rect.origin.y+1;
}

- (void)didPressedImageControl:(UIControl *)control
{
    NSString *imageUrlStr = [self.model.images objectAtIndex:control.tag];
    if ([self.delegate respondsToSelector:@selector(didPressedImage:)]) {
        [self.delegate didPressedImage:imageUrlStr];
    }
}


@end
