//
//  MLAfterSalesGoodsTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 2/1/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAfterSalesGoodsTableViewCell.h"
#import "Header.h"

@interface MLAfterSalesGoodsTableViewCell ()

@property (readwrite) UIImageView *iconView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *priceLabel;
@property (readwrite) UILabel *numberLabel;
@property (readwrite) UILabel *statusLabel;

@end

@implementation MLAfterSalesGoodsTableViewCell

+ (CGFloat)height {
	return 94;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
		CGRect rect = CGRectZero;
		rect.origin.x = edgeInsets.left;
		rect.origin.y = edgeInsets.top;
		rect.size.width = 64;
		rect.size.height = rect.size.width;
		_iconView = [[UIImageView alloc] initWithFrame:rect];
		_iconView.contentMode = UIViewContentModeScaleAspectFit;
		_iconView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		_iconView.layer.borderWidth = 0.5;
		[self.contentView addSubview:_iconView];
		
		rect.origin.x = CGRectGetMaxX(_iconView.frame) + 10;
		rect.size.width = fullWidth - rect.origin.x - edgeInsets.right;
		rect.size.height = 25;
		_nameLabel = [[UILabel alloc] initWithFrame:rect];
		_nameLabel.font = [UIFont systemFontOfSize:16];
		[self.contentView addSubview:_nameLabel];
		
		rect.origin.y = CGRectGetMaxY(_nameLabel.frame);
		rect.size.width = fullWidth - rect.origin.x;
		rect.size.height = 20;
		_priceLabel = [[UILabel alloc] initWithFrame:rect];
		_priceLabel.font = [UIFont systemFontOfSize:13];
		_priceLabel.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:_priceLabel];
		
		rect.origin.x = 200;
		_numberLabel = [[UILabel alloc] initWithFrame:rect];
		_numberLabel.font = _priceLabel.font;
		_numberLabel.textColor = _priceLabel.textColor;
		[self.contentView addSubview:_numberLabel];
		
		rect.origin.x = CGRectGetMinX(_priceLabel.frame);
		rect.origin.y = CGRectGetMaxY(_priceLabel.frame);
		_statusLabel = [[UILabel alloc] initWithFrame:rect];
		_statusLabel.font = [UIFont systemFontOfSize:13];
		_statusLabel.textColor = [UIColor fontGrayColor];
		_statusLabel.numberOfLines = 0;
		[self.contentView addSubview:_statusLabel];
	}
	return self;
}

- (void)setAfterSalesGoods:(MLAfterSalesGoods *)afterSalesGoods {
	_afterSalesGoods = afterSalesGoods;
	if (_afterSalesGoods) {
		[_iconView setImageWithURL:[NSURL URLWithString:_afterSalesGoods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		_nameLabel.text = _afterSalesGoods.name;
		_priceLabel.text = [NSString stringWithFormat:@"价格:¥%0.2f", [_afterSalesGoods.price floatValue]];
		_numberLabel.text = [NSString stringWithFormat:@"数量:%@", _afterSalesGoods.number];
		NSString *string = [NSString stringWithFormat:@"状态:%@", _afterSalesGoods.status];
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
		[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor themeColor] range:NSMakeRange(3, string.length - 3)];
		_statusLabel.attributedText = attributedString;
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_iconView.image = nil;
	_priceLabel.text = nil;
	_numberLabel.text = nil;
	_nameLabel.text = nil;
	_statusLabel.text = nil;
}

@end
