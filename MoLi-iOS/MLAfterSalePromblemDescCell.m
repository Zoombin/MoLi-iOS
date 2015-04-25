//
//  MLAfterSalePromblemDescCell.m
//  MoLi
//
//  Created by LLToo on 15/4/14.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLAfterSalePromblemDescCell.h"
#import "MLCache.h"

@interface MLAfterSalePromblemDescCell()

@property (nonatomic,weak)  UILabel *lblProDesc;        //问题描述


@end

@implementation MLAfterSalePromblemDescCell {
    CGFloat height;
}

+ (CGFloat)height:(BOOL)isBremark{
    //是否有卖家反馈
    if (isBremark) {
        return 115;
    }
    else {
        return 80;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (void)setAfterSaleGoodsDetailDict:(NSDictionary *)dict
{
    _afterSaleGoodsDetailDict = dict;
    
    CGFloat leftWidth = 65;
    CGFloat offsetY = 70;
    CGFloat rightWidth = WINSIZE.width-offsetY-20;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 15, 10, 15);
    CGRect rect = CGRectZero;
    rect.origin.x = edgeInsets.left;
    rect.size.height = 28;
    rect.origin.y = edgeInsets.top;
    rect.size.width = leftWidth;
    
    UILabel *leftTitleLbl = [MLAfterSalePromblemDescCell leftTitleLabel:@"问题描述:"];
    leftTitleLbl.frame = rect;
    [self.contentView addSubview:leftTitleLbl];
    
    rect.origin.x = rect.origin.x+offsetY;
    rect.size.width = rightWidth;
    _lblProDesc = [MLAfterSalePromblemDescCell rightTitleLabel];
    _lblProDesc.frame = rect;
    NSString *uremark = [[dict objectForKey:@"service"] objectForKey:@"uremark"];
    _lblProDesc.text = [MLCache isNullObject:uremark]?@"":uremark;
    [self.contentView addSubview:_lblProDesc];
    
    NSString *bremark = [[dict objectForKey:@"service"] objectForKey:@"bremark"];
    if(![MLCache isNullObject:bremark]) {
        rect.origin.y += 28;
        rect.origin.x = edgeInsets.left;
        rect.size.width = leftWidth;
        
        leftTitleLbl = [MLAfterSalePromblemDescCell leftTitleLabel:@"商家备注:"];
        leftTitleLbl.frame = rect;
        [self.contentView addSubview:leftTitleLbl];
        
        rect.origin.x = rect.origin.x+offsetY;
        rect.size.width = rightWidth;
        UILabel *bremarkLbl = [MLAfterSalePromblemDescCell rightTitleLabel];
        bremarkLbl.frame = rect;
        bremarkLbl.text = bremark;
        [self.contentView addSubview:bremarkLbl];
    }
    
    
    rect.origin.y += 28;
    rect.origin.x = edgeInsets.left;
    rect.size.width = leftWidth;
    
    leftTitleLbl = [MLAfterSalePromblemDescCell leftTitleLabel:@"图片凭证:"];
    leftTitleLbl.frame = rect;
    [self.contentView addSubview:leftTitleLbl];
    
    CGRect imgRect = CGRectMake(rect.origin.x+65, rect.origin.y, 250, 40);
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:imgRect];
    scroll.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:scroll];
    
    
    imgRect = CGRectMake(0, 0, 40, 40);
    
    NSArray *arrImgs = [[dict objectForKey:@"service"] objectForKey:@"images"];
    if(arrImgs) {
        for (NSString *imgStr in arrImgs) {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:imgRect];
            imgview.layer.cornerRadius = 5.0;
            [imgview setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"Avatar"]];
            [scroll addSubview:imgview];
            
            imgRect.origin.x += 45;
        }
    }
    [scroll setContentSize:CGSizeMake(imgRect.origin.x, 40)];
    
    // 添加锯齿
    UIImageView *cornerLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cornerline"]];
    if (_isBremark) {
        cornerLineView.frame = CGRectMake(0, 115 - cornerLineView.frame.size.height, WINSIZE.width, cornerLineView.frame.size.height);
    } else {
        cornerLineView.frame = CGRectMake(0, 80 - cornerLineView.frame.size.height, WINSIZE.width, cornerLineView.frame.size.height);
    }
    [self addSubview:cornerLineView];
}


+ (UILabel *)leftTitleLabel:(NSString *)title
{
    UILabel *leftTitleLbl =[[UILabel alloc] init];
    leftTitleLbl.textAlignment = NSTextAlignmentLeft;
    leftTitleLbl.textColor = [UIColor blackColor];
    leftTitleLbl.font = [UIFont systemFontOfSize:15];
    leftTitleLbl.text = title;
    return leftTitleLbl;
}

+ (UILabel *)rightTitleLabel
{
    UILabel *leftTitleLbl =[[UILabel alloc] init];
    leftTitleLbl.textAlignment = NSTextAlignmentLeft;
    leftTitleLbl.textColor = [UIColor darkGrayColor];
    leftTitleLbl.font = [UIFont systemFontOfSize:15];
    return leftTitleLbl;
}

@end
