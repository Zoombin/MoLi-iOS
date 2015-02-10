//
//  MLGoodsTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/10/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoodsTableViewCell.h"
#import "Header.h"

@interface MLGoodsTableViewCell ()

@property (readwrite) UIImageView *iconView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *describeLabel;
@property (readwrite) UILabel *priceLabel;
@property (readwrite) UILabel *quantityLabel;

@end

@implementation MLGoodsTableViewCell

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
		
		CGFloat widthOfPriceLabel = 50;
		rect.origin.x = CGRectGetMaxX(_iconView.frame) + 10;
		rect.size.width = fullWidth - rect.origin.x - widthOfPriceLabel - edgeInsets.right;
		rect.size.height = 40;
		_nameLabel = [[UILabel alloc] initWithFrame:rect];
		_nameLabel.numberOfLines = 0;
		_nameLabel.font = [UIFont systemFontOfSize:16];
		[self.contentView addSubview:_nameLabel];
		
		rect.origin.y = CGRectGetMaxY(_nameLabel.frame) + 5;
		rect.size.height = 20;
		_describeLabel = [[UILabel alloc] initWithFrame:rect];
		_describeLabel.font = [UIFont systemFontOfSize:13];
		_describeLabel.textColor = [UIColor fontGrayColor];
		_describeLabel.numberOfLines = 0;
		[self.contentView addSubview:_describeLabel];
		
		rect.size.width = widthOfPriceLabel;
		rect.size.height = 20;
		rect.origin.x = fullWidth - edgeInsets.right - rect.size.width;
		rect.origin.y = edgeInsets.top;
		_priceLabel = [[UILabel alloc] initWithFrame:rect];
		_priceLabel.font = [UIFont systemFontOfSize:13];
		_priceLabel.textColor = [UIColor fontGrayColor];
		_priceLabel.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:_priceLabel];
		
		rect.origin.y = CGRectGetMaxY(_priceLabel.frame);
		_quantityLabel = [[UILabel alloc] initWithFrame:rect];
		_quantityLabel.font = _priceLabel.font;
		_quantityLabel.textColor = _priceLabel.textColor;
		_quantityLabel.textAlignment = _priceLabel.textAlignment;
		[self.contentView addSubview:_quantityLabel];
	}
	return self;
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
	if (_goods) {
		[_iconView setImageWithURL:[NSURL URLWithString:_goods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		_nameLabel.text = _goods.name;
		NSString *details = [NSString stringWithFormat:@"价格:¥%@\n销量:%@    好评率:%@％", _goods.price, _goods.salesVolume, _goods.highOpinion];
		_describeLabel.text = details;
	}
}

- (void)setCartMode:(BOOL)cartMode {
	_cartMode = cartMode;
	if (_cartMode) {
		_describeLabel.text = _goods.displayGoodsPropertiesInCart;
	}
	_priceLabel.text = [NSString stringWithFormat:@"¥%@", _goods.price];
	_quantityLabel.text = [NSString stringWithFormat:@"数量:%@", _goods.quantityInCart];
	_priceLabel.hidden = !_cartMode;
	_quantityLabel.hidden = !_cartMode;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_iconView.image = nil;
	_priceLabel.text = nil;
	_quantityLabel.text = nil;
	_nameLabel.text = nil;
	_describeLabel.text = nil;
	self.imageView.image = nil;
	self.textLabel.text = nil;
	self.detailTextLabel.text = nil;
}

@end
