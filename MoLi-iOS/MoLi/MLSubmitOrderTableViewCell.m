//
//  MLSubmitOrderTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLSubmitOrderTableViewCell.h"
#import "Header.h"

@interface MLSubmitOrderTableViewCell ()

@property (readwrite) UILabel *priceLabel;
@property (readwrite) UIButton *submitButton;

@end

@implementation MLSubmitOrderTableViewCell

+ (CGFloat)height {
	return 50;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.textLabel.text = @"总价金额:";
		self.textLabel.font = [UIFont systemFontOfSize:13];
		self.textLabel.textColor = [UIColor fontGrayColor];
		
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, fullWidth - 70, [[self class] height])];
		_priceLabel.textColor = [UIColor themeColor];
		_priceLabel.font = [UIFont systemFontOfSize:16];
		[self.contentView addSubview:_priceLabel];
		
		_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_submitButton.frame = CGRectMake(fullWidth - 100, 0, 100, [[self class] height]);
		_submitButton.backgroundColor = [UIColor themeColor];
		[_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
		[_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_submitButton.showsTouchWhenHighlighted = YES;
		[_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_submitButton];
	}
	return self;
}

- (void)setPrice:(NSNumber *)price {
	_price = price;
	if (_price) {
		_priceLabel.text = [NSString stringWithFormat:@"¥%.2f", _price.floatValue];
	}
}

- (void)submit {
	if (_delegate) {
		[_delegate submitOrder];
	}
}

@end
