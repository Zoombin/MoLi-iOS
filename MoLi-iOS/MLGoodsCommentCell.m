//
//  MLGoodsCommentCell.m
//  MoLi
//
//  Created by LLToo on 15/4/17.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLGoodsCommentCell.h"
#import "UIImageView+AFNetworking.h"

@interface MLGoodsCommentCell()

@property (nonatomic,strong) UILabel *lblComment;

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

- (void)setShowInfo:(NSDictionary *)dict
{
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
    self.lblComment.text = [dict objectForKey:@"content"];
    [self.contentView addSubview:self.lblComment];
    
    rect.origin.y += 30;
    
    NSArray *images = [dict objectForKey:@"images"];
    if (images.count>0) {
        for (int i =0; i<images.count; i++) {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x+55*i, rect.origin.y, 50, 50)];
            imgview.layer.masksToBounds = YES;
            imgview.layer.cornerRadius = 4;
            [imgview setImageWithURL:[NSURL URLWithString:[images objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"Avatar"]];
            [self.contentView addSubview:imgview];
        }
        rect.origin.y+= 55;
    }
    
    rect.origin.x = edgeInsets.left;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.textColor = [UIColor fontGrayColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = [dict objectForKey:@"spec"];
    [self.contentView addSubview:lbl];
    
    rect.origin.y += 30;
    rect.size.width = WINSIZE.width/2.0;
    lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.textColor = [UIColor fontGrayColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = [dict objectForKey:@"username"];
    [self.contentView addSubview:lbl];
    
    rect.origin.x = WINSIZE.width/2.0;
    rect.size.width = WINSIZE.width/2.0-15;
    lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.textColor = [UIColor fontGrayColor];
    lbl.textAlignment = NSTextAlignmentRight;
    lbl.text = [dict objectForKey:@"senddate"];
    [self.contentView addSubview:lbl];
    
    rect.origin.y += 30;
    rect.origin.x = edgeInsets.left;
    rect.size.width = WINSIZE.width-15;
    rect.size.height = 0.5;
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:rect];
    [lineView dottedLine:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1]];
    [self addSubview:lineView];
    
    self.height = rect.origin.y+1;
    
}

@end
