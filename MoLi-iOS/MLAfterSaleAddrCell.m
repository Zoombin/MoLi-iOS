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
    
    CGFloat addlablHeight = [self labelHeight:addrLbl.text withFontSize:15 withDisplay:rect.size.width];
    
    CGSize size = [addrLbl boundingRectWithSize:CGSizeMake(rect.size.width, 30)];
    addrLbl.frame = CGRectMake(addrLbl.frame.origin.x, addrLbl.frame.origin.y, size.width, addlablHeight);
    addrLbl.numberOfLines = 99;
    
    
    
    NSString *postcode = [[dict objectForKey:@"address"] objectForKey:@"postcode"];
    rect.origin.y += addrLbl.frame.size.height;
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
    cornerLineView.frame = CGRectMake(0, rect.origin.y+35-cornerLineView.frame.size.height, WINSIZE.width, cornerLineView.frame.size.height);
    [self addSubview:cornerLineView];
    
    self.height = cornerLineView.frame.origin.y+cornerLineView.frame.size.height;
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

-(CGFloat)labelHeight:(NSString*)string withFontSize:(CGFloat)fontsize withDisplay:(CGFloat)display{
    UIFont *fontsize1 = [UIFont systemFontOfSize:fontsize];
    CGSize constraint1 = CGSizeMake(display, 20000.0f);
    CGFloat labelheight;
    
    //    if (DEF_IOS7LATTER) {
    CGRect addressSize1 = [string boundingRectWithSize:constraint1 options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:fontsize1 forKey:NSFontAttributeName] context:nil];
    labelheight = addressSize1.size.height+10;
    //    }else{
    //        CGSize addressSize = [model.content sizeWithFont:fontsize1 constrainedToSize:constraint1 lineBreakMode:NSLineBreakByWordWrapping];
    //         labelheight = addressSize.height+10;
    //    }
    return labelheight;
    
}

@end
