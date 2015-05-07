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

@property (nonatomic,strong)  UILabel *lblGoodsName;      //商品名
@property (nonatomic,strong)  UILabel *lblGoodsType;      //售后类型
@property (nonatomic,strong)  UILabel *lblGoodsState;     //售后状态
@property (nonatomic,strong)  UILabel *lblGoodsTime;      //申请时间
@property (nonatomic,strong)  UILabel *lblReturnPrice;    //退款金额
@property (nonatomic,strong)  UILabel *lblReturnTicket;    //退款金额

@property (nonatomic) MLAfterSalesType salesType;

@end

@implementation MLAfterSaleGoodsDetailCell

+ (CGFloat)height:(MLAfterSalesType)type {
    if(type==MLAfterSalesTypeChange)
        return 115;
    else
        return 180;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(MLAfterSalesType)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.salesType = type;
    }
    return self;
}


- (void)setSubviews:(NSDictionary *)dict
{
    CGFloat leftWidth = 65;
    CGFloat offsetY = 70;
    CGFloat rightWidth = WINSIZE.width-offsetY-20;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 15, 10, 15);
    CGRect rect = CGRectZero;
    rect.origin.x = edgeInsets.left;
    rect.size.height = 28;
    rect.origin.y = edgeInsets.top;
    rect.size.width = leftWidth;
    
    UILabel *leftTitleLbl = [MLAfterSaleGoodsDetailCell leftTitleLabel:@"商品名:"];
    leftTitleLbl.frame = rect;
    [self.contentView addSubview:leftTitleLbl];
    
    rect.origin.x = rect.origin.x+offsetY;
    rect.size.width = rightWidth;
    _lblGoodsName = [MLAfterSaleGoodsDetailCell rightTitleLabel];
    _lblGoodsName.frame = rect;
    [self.contentView addSubview:_lblGoodsName];
    _lblGoodsName.text = [[dict objectForKey:@"goods"] objectForKey:@"name"];
    _lblGoodsName.numberOfLines = 99;
    
    CGFloat addlablHeight = [self labelHeight:_lblGoodsName.text withFontSize:15 withDisplay:rightWidth];

    CGSize size = [_lblGoodsName boundingRectWithSize:CGSizeMake(rightWidth, 30)];
    _lblGoodsName.frame = CGRectMake(_lblGoodsName.frame.origin.x, _lblGoodsName.frame.origin.y, size.width, addlablHeight);

    
    rect.origin.y += _lblGoodsName.frame.size.height;
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
    
    
    if(self.salesType==MLAfterSalesTypeReturn)
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
        
        
        rect.origin.y += 28;
        rect.origin.x = edgeInsets.left;
        rect.size.width = leftWidth+20;
        
        leftTitleLbl = [MLAfterSaleGoodsDetailCell leftTitleLabel:@"应退代金券:"];
        leftTitleLbl.frame = rect;
        [self.contentView addSubview:leftTitleLbl];
        
        rect.origin.x = rect.origin.x+offsetY+10;
        rect.size.width = rightWidth;
        _lblReturnTicket = [MLAfterSaleGoodsDetailCell rightTitleLabel];
        _lblReturnTicket.frame = rect;
        [self.contentView addSubview:_lblReturnTicket];
    }

    self.height = rect.origin.y+30;
    
}


- (void)setAfterSaleGoodsDetailDict:(NSDictionary *)dict
{
    _afterSaleGoodsDetailDict = dict;
    
    [self setSubviews:dict];
    

    _lblGoodsType.text = [[dict objectForKey:@"service"] objectForKey:@"typename"];
    _lblGoodsState.text = [[dict objectForKey:@"service"] objectForKey:@"statusname"];
    _lblGoodsTime.text = [[dict objectForKey:@"service"] objectForKey:@"createtime"];
    _lblReturnPrice.text = [NSString stringWithFormat:@"%@元",[[dict objectForKey:@"service"] objectForKey:@"refundamount"]];
    _lblReturnTicket.text = [NSString stringWithFormat:@"%@元",[[dict objectForKey:@"service"] objectForKey:@"refundvoucher"]];
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
