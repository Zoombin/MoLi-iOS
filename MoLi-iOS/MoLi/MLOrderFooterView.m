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
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(12, 10, 16, 15);
	CGRect rect = CGRectZero;
	rect.size.width = 80;
	rect.size.height = 34;
	rect.origin.y = edgeInsets.top;
	NSMutableArray *tmp = [NSMutableArray array];
	for (int i = 0; i < operators.count; i++) {
		rect.origin.x = self.bounds.size.width - ((rect.size.width + edgeInsets.right) * (i + 1));
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = rect;
		button.layer.borderWidth = 0.5;
		button.layer.borderColor = [[UIColor borderGrayColor] CGColor];
		button.layer.cornerRadius = 4;
		button.showsTouchWhenHighlighted = YES;
		button.titleLabel.font = [UIFont systemFontOfSize:13];
		button.titleLabel.adjustsFontSizeToFitWidth = YES;
		
		MLOrderOperator *operator = operators[i];
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
