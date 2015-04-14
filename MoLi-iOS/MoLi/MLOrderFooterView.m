//
//  MLOrderFooterView.m
//  MoLi
//
//  Created by zhangbin on 12/30/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLOrderFooterView.h"
#import "Header.h"

@interface MLOrderFooterView ()

@property (readwrite) NSArray *buttons;

@end

@implementation MLOrderFooterView

+ (CGFloat)height {
	return 60;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)setOrder:(MLOrder *)order {
	_order = order;
	if (_order) {
		[self createButtonsWithOperators:_order.operators];
	}
}

- (void)setAfterSalesGoods:(MLAfterSalesGoods *)afterSalesGoods {
	_afterSalesGoods = afterSalesGoods;
	if (_afterSalesGoods) {
		[self createButtonsWithOperators:afterSalesGoods.orderOperators];
	}
}

- (void)createButtonsWithOperators:(NSArray *)operators {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(self.bNoNeedCornerLine?0:12, 10, 16, 15);
	CGRect rect = CGRectZero;
	rect.size.width = 90;
	rect.size.height = 34;
	rect.origin.y = edgeInsets.top;
    
    // 绘制虚线
    if(!self.bNoNeedCornerLine) {
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, WINSIZE.width - 20, 1)];
        [lineView dottedLine:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1]];
        [self addSubview:lineView];
    }
    
	NSMutableArray *tmp = [NSMutableArray array];
    for (int i = 0; i < operators.count; i++) {
        MLOrderOperator *operator = operators[i];
        
        rect.size.width = operator.name.length > 4 ? 100 : 80;
		rect.origin.x = self.bounds.size.width - ((rect.size.width + edgeInsets.right) * (i + 1));
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = rect;
		button.layer.borderWidth = 0.5;
		button.layer.borderColor = [[UIColor borderGrayColor] CGColor];
		button.layer.cornerRadius = 4;
		button.showsTouchWhenHighlighted = YES;
		button.titleLabel.font = [UIFont systemFontOfSize:13];
		button.titleLabel.adjustsFontSizeToFitWidth = YES;
		
		UIColor *backgroundColor = [UIColor hexRGB:[operator.backgroundHexColor hexUInteger]];
		UIColor *fontColor = [UIColor hexRGB:[operator.fontHexColor hexUInteger]];
		[button setTitle:operator.name forState:UIControlStateNormal];
		[button setTitleColor:fontColor forState:UIControlStateNormal];
		[button setBackgroundColor:backgroundColor];
		button.tag = i;
		[button addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
		[tmp addObject:button];
	}
	_buttons = [NSArray arrayWithArray:tmp];
    // 添加锯齿
    if(!self.bNoNeedCornerLine) {
        UIImageView *cornerLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cornerline"]];
        cornerLineView.frame = CGRectMake(0, rect.origin.y + rect.size.height + 10, WINSIZE.width, cornerLineView.frame.size.height);
        [self addSubview:cornerLineView];
    }
}

- (void)tapped:(UIButton *)sender {
	if (_delegate) {
		if (_order) {
			[_delegate executeOrder:_order withOperator:_order.operators[sender.tag]];
		}
		
		if (_afterSalesGoods) {
			[_delegate executeAfterSalesGoods:_afterSalesGoods withOperator:_afterSalesGoods.orderOperators[sender.tag]];
		}
	}
}

@end
