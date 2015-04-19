//
//  MLCommentFooter.m
//  MoLi
//
//  Created by zhangbin on 2/1/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLCommentFooter.h"
#import "Header.h"

@interface MLCommentFooter () <UITextFieldDelegate>

@property (readwrite) UILabel *shippingLabel;
@property (readwrite) UITextField *commentTextField;
@property (readwrite) UILabel *storeNameLabel;
@property (readwrite) UILabel *numberLabel;
@property (readwrite) UILabel *priceLabel;

@end

@implementation MLCommentFooter

+ (CGFloat)height {
	return 128;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 15, 5, 15);
		CGRect rect = CGRectZero;
		rect.origin.x = edgeInsets.left;
		rect.origin.y = edgeInsets.top;
		rect.size.width = self.bounds.size.width - edgeInsets.left - edgeInsets.right;
		rect.size.height = 20;
		_shippingLabel = [[UILabel alloc] initWithFrame:rect];
		_shippingLabel.font = [UIFont systemFontOfSize:13];
		_shippingLabel.textColor = [UIColor fontGrayColor];
//		_shippingLabel.text = @"配送方式:快递8元";
		[self addSubview:_shippingLabel];
		
		rect.origin.y = CGRectGetMaxY(_shippingLabel.frame) + 5;
		rect.size.height = 34;
		_commentTextField = [[UITextField alloc] initWithFrame:rect];
		_commentTextField.placeholder = @"给商家留言";
		_commentTextField.layer.borderWidth = 0.5;
		_commentTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		_commentTextField.delegate = self;
		[_commentTextField addTarget:self action:@selector(changedComment:) forControlEvents:UIControlEventEditingChanged];
		[self addSubview:_commentTextField];
		
		rect.origin.y = CGRectGetMaxY(_commentTextField.frame) + 16;
		rect.size.height = 0.5;
		UIView *line = [[UIView alloc] initWithFrame:rect];
		line.backgroundColor = [UIColor lightGrayColor];
		[self addSubview:line];
		
		rect.origin.y = CGRectGetMaxY(line.frame) + 15;
		rect.size.width = 24;
		rect.size.height = rect.size.width;
		UIImageView *iconView = [[UIImageView alloc] initWithFrame:rect];
		iconView.image = [UIImage imageNamed:@"Store"];
		[self addSubview:iconView];
		
		rect.origin.x = CGRectGetMaxX(iconView.frame) + 5;
		rect.size.width = self.bounds.size.width;
		_storeNameLabel = [[UILabel alloc] initWithFrame:rect];
		_storeNameLabel.textColor = [UIColor blackColor];
//		_storeNameLabel.text = @"竟平点";
		[self addSubview:_storeNameLabel];
		
		rect.origin.x = edgeInsets.left;
		rect.origin.y = CGRectGetMaxY(line.frame) + 5;
		rect.size.width = self.bounds.size.width - edgeInsets.left - edgeInsets.right;
		rect.size.height = 20;
		_numberLabel = [[UILabel alloc] initWithFrame:rect];
//		_numberLabel.text = @"数量:8";
		_numberLabel.font = [UIFont systemFontOfSize:9];
		_numberLabel.textColor = [UIColor fontGrayColor];
		_numberLabel.textAlignment = NSTextAlignmentRight;
		[self addSubview:_numberLabel];
		
		rect.origin.y = CGRectGetMaxY(_numberLabel.frame) - 5;
		rect.size.height = 25;
		_priceLabel = [[UILabel alloc] initWithFrame:rect];
		_priceLabel.textColor = [UIColor themeColor];
		_priceLabel.textAlignment = NSTextAlignmentRight;
		_priceLabel.font = [UIFont systemFontOfSize:16];
		[self addSubview:_priceLabel];
	}
	return self;
}

- (void)setCartStore:(MLCartStore *)cartStore {
	_cartStore = cartStore;
	if (_cartStore) {
		_storeNameLabel.text = _cartStore.name;
		_commentTextField.text = _cartStore.commentWillSend;
		_shippingLabel.text = [NSString stringWithFormat:@"配送方式:%@", _cartStore.shippingName ?: @""];
		_numberLabel.text = [NSString stringWithFormat:@"数量:%@", _cartStore.numberOfGoods];
		_priceLabel.text = [NSString stringWithFormat:@"¥%.2f", _cartStore.totalPrice.floatValue];
	}
}

- (void)changedComment:(UITextField *)textField {
	if (_cartStore) {
		_cartStore.commentWillSend = textField.text;
	}
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (_cartStore) {
		_cartStore.commentWillSend = textField.text;
	}
}

@end
