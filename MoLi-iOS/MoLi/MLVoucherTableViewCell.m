//
//  MLVoucherTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLVoucherTableViewCell.h"
#import "Header.h"

@interface MLVoucherTableViewCell ()

@property (readwrite) UILabel *label;
@property (readwrite) UILabel *describeLabel;

@end

@implementation MLVoucherTableViewCell

+ (CGFloat)height {
	return 100.5;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		CGRect rect = CGRectMake(0, 0, fullWidth, [[self class] height]);
		UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:rect];
		backgroundView.image = [UIImage imageNamed:@"VoucherBackground"];
		[self.contentView addSubview:backgroundView];
		
		rect.size.width = 100;
		rect.size.height = 70;
		_label = [[UILabel alloc] initWithFrame:rect];
		_label.font = [UIFont systemFontOfSize:42];
		_label.textColor = [UIColor themeColor];
		_label.textAlignment = NSTextAlignmentRight;
		_label.text = @"120";
		[self.contentView addSubview:_label];
		
		rect.origin.x = CGRectGetMaxX(_label.frame);
		rect.origin.y = 30;
		rect.size.width = 25;
		rect.size.height = 25;
		UILabel *moneySymbolLabel = [[UILabel alloc] initWithFrame:rect];
		moneySymbolLabel.text = @"元";
		moneySymbolLabel.textColor = [UIColor themeColor];
		moneySymbolLabel.font = [UIFont systemFontOfSize:15];
		[self.contentView addSubview:moneySymbolLabel];
		
		rect.origin.x = CGRectGetMaxX(moneySymbolLabel.frame);
		rect.origin.y = 10;
		rect.size.width = fullWidth - rect.origin.x;
		rect.size.height = 40;
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:rect];
		nameLabel.text = @"代金券";
		nameLabel.textColor = [UIColor colorWithRed:249/255.0f green:138/255.f blue:51/255.0f alpha:1.0f];
		nameLabel.font = [UIFont boldSystemFontOfSize:22];
		[self.contentView addSubview:nameLabel];
		
		rect.origin.y = CGRectGetMaxY(nameLabel.frame) - 10;
		rect.size.height = 20;
		_describeLabel = [[UILabel alloc] initWithFrame:rect];
		_describeLabel.font = [UIFont systemFontOfSize:9];
		_describeLabel.textColor = nameLabel.textColor;
		[self.contentView addSubview:_describeLabel];
		
		
		rect.origin.x = 0;
		rect.origin.y = CGRectGetMaxY(_label.frame);
		rect.size.width = fullWidth;
		rect.size.height = [[self class] height] - rect.origin.y;
		UILabel *bottomLabel = [[UILabel alloc] initWithFrame:rect];
		bottomLabel.text = @"点击翻开查看使用细则";
		bottomLabel.textColor = [UIColor themeColor];
		bottomLabel.font = _describeLabel.font;
		bottomLabel.textAlignment = NSTextAlignmentCenter;
		[self.contentView addSubview:bottomLabel];
		
//		rect.origin.x =
//		UIView *line = [[UIView alloc] initWithCoder:rect];
//		
	}
	return self;
}

- (void)setVoucher:(MLVoucher *)voucher {
	_voucher = voucher;
	if (_voucher) {
		_label.text = [NSString stringWithFormat:@"%@", _voucher.voucherWillGet];
		_describeLabel.text = [NSString stringWithFormat:@"此次购物成功后共获得%@元代金券", _voucher.voucherWillGet];
	}
}


@end
