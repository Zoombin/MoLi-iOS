//
//  MLUseVoucherTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLUseVoucherTableViewCell.h"
#import "Header.h"

@interface MLUseVoucherTableViewCell ()

@property (readwrite) UIButton *selectVoucherButton;
@property (readwrite) UILabel *voucherLabel;

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
		_voucherLabel = [[UILabel alloc] initWithFrame:rect];
		_voucherLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		_voucherLabel.layer.borderWidth = 0.5;
		_voucherLabel.textAlignment = NSTextAlignmentCenter;
		_voucherLabel.textColor = [UIColor lightGrayColor];
		[self.contentView addSubview:_voucherLabel];
	}
	return self;
}

- (void)setVoucher:(MLVoucher *)voucher {
	_voucher = voucher;
	if (_voucher) {
		_voucherLabel.text = [NSString stringWithFormat:@"%@", _voucher.voucherCanCost];
	}
}


- (void)setSelectedVoucher:(BOOL)selectedVoucher {
	_selectedVoucher = selectedVoucher;
	_selectVoucherButton.selected = _selectedVoucher;
}


@end
