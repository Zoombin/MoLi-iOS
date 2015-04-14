//
//  MLAfterSaleAddrCell.m
//  MoLi
//
//  Created by LLToo on 15/4/14.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLAfterSaleAddrCell.h"
#import "MLCache.h"

@implementation MLAfterSaleAddrCell

+ (CGFloat)height
{
    return 130;
}


- (void)setAfterSaleGoodsDetailDict:(NSDictionary *)dict
{
    _afterSaleGoodsDetailDict = dict;
 
    // 添加信封条
    UIImageView *cornerLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DefaultAddressLine"]];
    cornerLineView.frame = CGRectMake(0, 0, WINSIZE.width, cornerLineView.frame.size.height);
    [self addSubview:cornerLineView];
    
//    CGFloat leftWidth = 65;
//    CGFloat offsetY = 75;
//    CGFloat rightWidth = 200;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(8, 15, 10, 15);
    CGRect rect = CGRectZero;
    rect.origin.x = edgeInsets.left;
    rect.size.height = 28;
    rect.origin.y = edgeInsets.top;
    rect.size.width = WINSIZE.width-30;
    
    UILabel *topLbl = [MLAfterSaleAddrCell topTitleLabel:@"我的收货地址"];
    topLbl.frame = rect;
    [self.contentView addSubview:topLbl];
    
    rect.origin.y += 28;
    rect.size.height = 0.5;
    UIView *lineview = [[UIView alloc] initWithFrame:rect];
    lineview.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineview];
    
    rect.origin.y += 5;
    rect.size.height = 28;
    NSString *address = [[dict objectForKey:@"address"] objectForKey:@"address"];
    UILabel *addrLbl = [MLAfterSaleAddrCell rightTitleLabel];
    addrLbl.text = [MLCache isNullObject:address]?@"":address;
    addrLbl.frame = rect;
    [self.contentView addSubview:addrLbl];
    
    NSString *postcode = [[dict objectForKey:@"address"] objectForKey:@"postcode"];
    rect.origin.y += 25;
    UILabel *lbl = [MLAfterSaleAddrCell rightTitleLabel];
    lbl.text = [NSString stringWithFormat:@"邮编: %@",[MLCache isNullObject:postcode]?@"":postcode];
    lbl.frame = rect;
    [self.contentView addSubview:lbl];
    
    rect.origin.y += 25;
    lbl = [MLAfterSaleAddrCell rightTitleLabel];
    NSString *name = [[dict objectForKey:@"address"] objectForKey:@"name"];
    NSString *tel = [[dict objectForKey:@"address"] objectForKey:@"tel"];
    
    lbl.text = [NSString stringWithFormat:@"%@    %@",[MLCache isNullObject:name]?@"":name,[MLCache isNullObject:tel]?@"":tel];
    lbl.frame = rect;
    [self.contentView addSubview:lbl];
 
    // 添加信封条
    cornerLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cornerline"]];
    cornerLineView.frame = CGRectMake(0, 130-cornerLineView.frame.size.height, WINSIZE.width, cornerLineView.frame.size.height);
    [self addSubview:cornerLineView];
}


+ (UILabel *)topTitleLabel:(NSString *)title
{
    UILabel *leftTitleLbl =[[UILabel alloc] init];
    leftTitleLbl.textAlignment = NSTextAlignmentLeft;
    leftTitleLbl.textColor = [UIColor blackColor];
    leftTitleLbl.font = [UIFont systemFontOfSize:15];
    leftTitleLbl.text = title;
    return leftTitleLbl;
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
