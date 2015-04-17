//
//  MLUseVoucherTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLUseVoucherTableViewCell.h"
#import "Header.h"

@interface MLUseVoucherTableViewCell () <UITextFieldDelegate>

@property (readwrite) UIButton *selectVoucherButton;
@property (readwrite) UITextField *voucherTextField;

@end

@implementation MLUseVoucherTableViewCell


+ (CGFloat)height {
	return 50;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		CGRect rect = CGRectZero;
		rect.origin.x = 0;
		rect.origin.y = 4;
		rect.size.width = 40;
		rect.size.height = 40;
		
		_selectVoucherButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_selectVoucherButton.frame = rect;
		[_selectVoucherButton setImage:[UIImage imageNamed:@"GoodsUnselected"] forState:UIControlStateNormal];
		[_selectVoucherButton setImage:[UIImage imageNamed:@"GoodsSelected"] forState:UIControlStateSelected];
		[_selectVoucherButton addTarget:self action:@selector(selectVoucher:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_selectVoucherButton];
		
		rect.origin.x = CGRectGetMaxX(_selectVoucherButton.frame);
		rect.origin.y = 0;
		rect.size.width = fullWidth - rect.origin.x;
		rect.size.height = [[self class] height];
		
		UILabel *label = [[UILabel alloc] initWithFrame:rect];
		label.text = @"使用                     元代金券";
		label.font = [UIFont systemFontOfSize:15];
		label.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:label];
		
		rect.origin.x = 80;
		rect.origin.y = 13;
		rect.size.width = 70;
		rect.size.height = 26;
		_voucherTextField = [[UITextField alloc] initWithFrame:rect];
		_voucherTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		_voucherTextField.layer.borderWidth = 0.5;
		_voucherTextField.keyboardType = UIKeyboardTypeNumberPad;
		_voucherTextField.textAlignment = NSTextAlignmentCenter;
		_voucherTextField.textColor = [UIColor lightGrayColor];
		_voucherTextField.delegate = self;
		[self.contentView addSubview:_voucherTextField];
	}
	return self;
}

- (void)setVoucher:(MLVoucher *)voucher {
	_voucher = voucher;
	if (_voucher.voucherWillingUse) {
		_voucherTextField.text = [NSString stringWithFormat:@"%@", _voucher.voucherWillingUse];
	} else {
		_voucherTextField.text = [NSString stringWithFormat:@"%@", _voucher.voucherCanCost];
	}
}

- (void)setSelectedVoucher:(BOOL)selectedVoucher {
	_selectedVoucher = selectedVoucher;
	_selectVoucherButton.selected = _selectedVoucher;
	if (_selectedVoucher) {
		if (_voucher.voucherWillingUse) {
			_voucherTextField.text = [NSString stringWithFormat:@"%@", _voucher.voucherWillingUse];
		} else {
			_voucher.voucherWillingUse = @(_voucher.voucherCanCost.floatValue);
			_voucherTextField.text = [NSString stringWithFormat:@"%@", _voucher.voucherCanCost];
		}
	}
}

- (void)selectVoucher:(UIButton *)sender {
//	[self setSelected:!_selectedVoucher animated:YES];
	[self setSelectedVoucher:!_selectedVoucher];
	if (_delegate) {
		[_delegate selectedUseVoucher:_selectedVoucher];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	CGFloat number = [textField.text floatValue];
	if (_delegate) {
		[_delegate willingUseVoucherValue:@(number) inTextField:_voucherTextField];
	}
}

@end
