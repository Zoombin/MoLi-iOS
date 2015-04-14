//
//  MLAfterSaleGoodsDetailCell.m
//  MoLi
//
//  Created by LLToo on 15/4/11.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLAfterSaleGoodsDetailCell.h"
#import "MLAfterSalesGoods.h"

@interface MLAfterSaleGoodsDetailCell ()

@property (nonatomic,weak)  UILabel *lblGoodsName;      //商品名
@property (nonatomic,weak)  UILabel *lblGoodsType;      //售后类型
@property (nonatomic,weak)  UILabel *lblGoodsState;     //售后状态
@property (nonatomic,weak)  UILabel *lblGoodsTime;      //申请时间
@property (nonatomic,weak)  UILabel *lblReturnPrice;    //退款金额

@end

@implementation MLAfterSaleGoodsDetailCell

+ (CGFloat)height:(MLAfterSalesType)type {
    if(type==MLAfterSalesTypeChange)
        return 115;
    else
        return 150;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(MLAfterSalesType)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat leftWidth = 65;
        CGFloat offsetY = 65;
        CGFloat rightWidth = 200;
        
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 15, 10, 15);
        CGRect rect = CGRectZero;
        rect.origin.x = edgeInsets.left;
        rect.size.height = 28;
        rect.origin.y = edgeInsets.top;
        rect.size.width = leftWidth;
        
        UILabel *leftTitleLbl = [MLAfterSaleGoodsDetailCell leftTitleLabel:@"商品名:"];
        leftTitleLbl.frame = rect;
        [self.contentView addSubview:leftTitleLbl];
        
        rect.origin.x = rect.origin.y+offsetY;
        rect.size.width = rightWidth;
        _lblGoodsName = [MLAfterSaleGoodsDetailCell rightTitleLabel];
        _lblGoodsName.frame = rect;
        [self.contentView addSubview:_lblGoodsName];
        
        
        
        rect.origin.y += 28;
        rect.origin.x = edgeInsets.left;
        rect.size.width = leftWidth;
        
        leftTitleLbl = [MLAfterSaleGoodsDetailCell leftTitleLabel:@"售后类型:"];
        leftTitleLbl.frame = rect;
        [self.contentView addSubview:leftTitleLbl];
        
        rect.origin.x = rect.origin.x+offsetY;
        rect.size.width = rightWidth;
        _lblGoodsType = [MLAfterSaleGoodsDetailCell rightTitleLabel];
        _lblGoodsType.frame = rect;
        [self.contentView addSubview:_lblGoodsType];
        
        
        rect.origin.y += 28;
        rect.origin.x = edgeInsets.left;
        rect.size.width = leftWidth;
        
        leftTitleLbl = [MLAfterSaleGoodsDetailCell leftTitleLabel:@"售后状态:"];
        leftTitleLbl.frame = rect;
        [self.contentView addSubview:leftTitleLbl];
        
        rect.origin.x = rect.origin.x+offsetY;
        rect.size.width = rightWidth;
        _lblGoodsState = [MLAfterSaleGoodsDetailCell rightTitleLabel];
        _lblGoodsState.frame = rect;
        _lblGoodsState.textColor = [UIColor redColor];
        [self.contentView addSubview:_lblGoodsState];
        
        
        rect.origin.y += 28;
        rect.origin.x = edgeInsets.left;
        rect.size.width = leftWidth;
        
        leftTitleLbl = [MLAfterSaleGoodsDetailCell leftTitleLabel:@"申请时间:"];
        leftTitleLbl.frame = rect;
        [self.contentView addSubview:leftTitleLbl];
        
        rect.origin.x = rect.origin.x+offsetY;
        rect.size.width = rightWidth;
        _lblGoodsTime = [MLAfterSaleGoodsDetailCell rightTitleLabel];
        _lblGoodsTime.frame = rect;
        [self.contentView addSubview:_lblGoodsTime];
        
        
        if(type==MLAfterSalesTypeReturn)
        {
            rect.origin.y += 28;
            rect.origin.x = edgeInsets.left;
            rect.size.width = leftWidth;
            
            leftTitleLbl = [MLAfterSaleGoodsDetailCell leftTitleLabel:@"应退金额:"];
            leftTitleLbl.frame = rect;
            [self.contentView addSubview:leftTitleLbl];
            
            rect.origin.x = rect.origin.x+offsetY;
            rect.size.width = rightWidth;
            _lblReturnPrice = [MLAfterSaleGoodsDetailCell rightTitleLabel];
            _lblReturnPrice.frame = rect;
            [self.contentView addSubview:_lblReturnPrice];
        }
        
    }
    return self;
}


- (void)setAfterSaleGoodsDetailDict:(NSDictionary *)dict
{
    _afterSaleGoodsDetailDict = dict;
    _lblGoodsName.text = [[dict objectForKey:@"goods"] objectForKey:@"name"];
    _lblGoodsType.text = [[dict objectForKey:@"service"] objectForKey:@"typename"];
    _lblGoodsState.text = [[dict objectForKey:@"service"] objectForKey:@"statusname"];
    _lblGoodsTime.text = [[dict objectForKey:@"service"] objectForKey:@"createtime"];
    _lblReturnPrice.text = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"service"] objectForKey:@"refundamount"]];
}


+ (UILabel *)leftTitleLabel:(NSString *)title
{
    UILabel *leftTitleLbl =[[UILabel alloc] init];
    leftTitleLbl.textAlignment = NSTextAlignmentLeft;
    leftTitleLbl.textColor = [UIColor blackColor];
    leftTitleLbl.font = [UIFont systemFontOfSize:14];
    leftTitleLbl.text = title;
    return leftTitleLbl;
}

+ (UILabel *)rightTitleLabel
{
    UILabel *leftTitleLbl =[[UILabel alloc] init];
    leftTitleLbl.textAlignment = NSTextAlignmentLeft;
    leftTitleLbl.textColor = [UIColor darkGrayColor];
    leftTitleLbl.font = [UIFont systemFontOfSize:14];
    return leftTitleLbl;
}

@end
