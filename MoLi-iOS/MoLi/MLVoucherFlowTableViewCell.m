//
//  MLVoucherFlowTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/26/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLVoucherFlowTableViewCell.h"
#import "Header.h"

@interface MLVoucherFlowTableViewCell ()

@property (readwrite) UILabel *actionLabel;
@property (readwrite) UILabel *amountLabel;

@end

@implementation MLVoucherFlowTableViewCell

+ (CGFloat)height {
	return 88;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		CGFloat widthForAmountLabel = 66;
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
		
		CGRect rect = CGRectZero;
		rect.origin.x = edgeInsets.left;
		rect.origin.y = 0;
		rect.size.width = fullWidth - rect.origin.x - widthForAmountLabel;
		rect.size.height = [[self class] height];
		_actionLabel = [[UILabel alloc] initWithFrame:rect];
		_actionLabel.textColor = [UIColor fontGrayColor];
		_actionLabel.font = [UIFont systemFontOfSize:18];
		_actionLabel.numberOfLines = 0;
		[self.contentView addSubview:_actionLabel];
		
		rect.origin.x = fullWidth - widthForAmountLabel - edgeInsets.right;
		rect.size.width = widthForAmountLabel;
		rect.size.height = 70;
		_amountLabel = [[UILabel alloc] initWithFrame:rect];
		_amountLabel.textColor = [UIColor themeColor];
		_amountLabel.font = [UIFont systemFontOfSize:22];
		_amountLabel.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:_amountLabel];
		
		rect.origin.y = CGRectGetMaxY(_amountLabel.frame) - 20;
		rect.size.height = 20;
		UILabel *label = [[UILabel alloc] initWithFrame:rect];
		label.text = @"代金券";
		label.textColor = [UIColor fontGrayColor];
		label.font = [UIFont systemFontOfSize:13];
		label.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:label];
	}
	return self;
}

- (void)setVoucherFlow:(MLVoucherFlow *)voucherFlow {
	_voucherFlow = voucherFlow;
	if (_voucherFlow) {
		_actionLabel.text = _voucherFlow.action;
		_amountLabel.text = _voucherFlow.amount;
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_actionLabel.text = nil;
	_amountLabel.text = nil;
}

@end
