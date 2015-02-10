//
//  MLNewVoucherTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/26/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLNewVoucherTableViewCell.h"
#import "Header.h"

@interface MLNewVoucherTableViewCell ()

@property (readwrite) UIImageView *backgroundImageView;
@property (readwrite) UILabel *storeNameLabel;
@property (readwrite) UILabel *valueLabel;
@property (readwrite) UILabel *goodsNameLabel;

@end

@implementation MLNewVoucherTableViewCell

+ (CGFloat)height {
	return 120;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		UIImage *image = [UIImage imageNamed:@"NewVoucherBackground"];
		
		CGRect rect = CGRectZero;
		rect.origin.x = 15;
		rect.origin.y = 0;
		rect.size.width = fullWidth - 2 * 15;
		rect.size.height = [[self class] height];
		
		_backgroundImageView = [[UIImageView alloc] initWithFrame:rect];
		_backgroundImageView.image	= image;
		_backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
		[self.contentView addSubview:_backgroundImageView];
		
		rect.origin.x = 30;
		rect.origin.y = 0;
		rect.size.height = 30;
		_storeNameLabel = [[UILabel alloc] initWithFrame:rect];
		_storeNameLabel.textColor = [UIColor whiteColor];
		_storeNameLabel.font = [UIFont systemFontOfSize:13];
		[self.contentView addSubview:_storeNameLabel];
		
		rect.origin.x += 12;
		rect.origin.y = CGRectGetMaxY(_storeNameLabel.frame);
		rect.size.height = 50;
		_valueLabel = [[UILabel alloc] initWithFrame:rect];
		_valueLabel.textColor = [UIColor whiteColor];
		_valueLabel.font = [UIFont systemFontOfSize:44];
		[self.contentView addSubview:_valueLabel];
		
		rect.origin.x = CGRectGetMinX(_storeNameLabel.frame);
		rect.origin.y = 56;
		rect.size.width = 15;
		rect.size.height = 20;
		UILabel *symbolLabel = [[UILabel alloc] initWithFrame:rect];
		symbolLabel.textColor = [UIColor whiteColor];
		symbolLabel.text = @"¥";
		symbolLabel.font = [UIFont systemFontOfSize:16];
		[self.contentView addSubview:symbolLabel];
		
		rect.origin.y = CGRectGetMaxY(_valueLabel.frame) - 6;
		rect.size.width = fullWidth;
		rect.size.height = 30;
		_goodsNameLabel = [[UILabel alloc] initWithFrame:rect];
		_goodsNameLabel.textColor = [UIColor whiteColor];
		_goodsNameLabel.font = [UIFont systemFontOfSize:13];
		[self.contentView addSubview:_goodsNameLabel];
		
		rect.origin.x = fullWidth - 60;
		rect.origin.y = 0;
		rect.size.width = 40;
		rect.size.height = [[self class] height];
		UILabel *takeLabel = [[UILabel alloc] initWithFrame:rect];
		takeLabel.numberOfLines = 0;
		takeLabel.text = @"领\n取";
		takeLabel.textColor = [UIColor themeColor];
		takeLabel.font = [UIFont systemFontOfSize:24];
		takeLabel.userInteractionEnabled = YES;
		[self.contentView addSubview:takeLabel];
	}
	return self;
}

- (void)setVoucher:(MLVoucher *)voucher {
	_voucher = voucher;
	if (_voucher) {
		_storeNameLabel.text = _voucher.storeName;
		_goodsNameLabel.text = _voucher.goodsName;
		_valueLabel.text = [NSString stringWithFormat:@"%@", _voucher.value];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_storeNameLabel.text = nil;
	_goodsNameLabel.text = nil;
	_valueLabel.text = nil;
}

@end
