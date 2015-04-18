//
//  MLVoucherCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/31/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLVoucherCollectionViewCell.h"
#import "Header.h"

@interface MLVoucherCollectionViewCell ()

@property (nonatomic, strong) UILabel *voucherWillGetLabel;

@end

@implementation MLVoucherCollectionViewCell

+ (UIImage *)backgroundImage {
	return [UIImage imageNamed:@"VoucherBackground2"];
}

+ (CGFloat)height {
	return [self backgroundImage].size.height;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		backgroundImageView.image = [[self class] backgroundImage];
		[self.contentView addSubview:backgroundImageView];
		
		_voucherWillGetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, [[self class] height] - 30)];
		_voucherWillGetLabel.textColor = [UIColor themeColor];
		_voucherWillGetLabel.font = [UIFont boldSystemFontOfSize:40];
		_voucherWillGetLabel.textAlignment = NSTextAlignmentCenter;
		[self.contentView addSubview:_voucherWillGetLabel];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, [[self class] height] - 30, self.bounds.size.width, 30)];
		label.textColor = [UIColor themeColor];
		label.font = [UIFont systemFontOfSize:9];
		label.textAlignment = NSTextAlignmentCenter;
		label.text = @"此次购物后将获得代金券";
		[self.contentView addSubview:label];
	}
	return self;
}

- (void)setVoucher:(MLVoucher *)voucher {
	_voucher = voucher;
	if (_voucher) {
		if (_voucher.voucherWillGetRange.count == 2) {
			_voucherWillGetLabel.text = [NSString stringWithFormat:@"%.2f~%.2f元", _voucher.voucherWillGetRange[0].floatValue, _voucher.voucherWillGetRange[1].floatValue];
		}
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_voucherWillGetLabel.text = nil;
}

@end
