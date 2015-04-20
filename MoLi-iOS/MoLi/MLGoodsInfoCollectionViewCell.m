//
//  MLGoodsInfoCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/9/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGoodsInfoCollectionViewCell.h"
#import "Header.h"

@interface MLGoodsInfoCollectionViewCell ()

@property (readwrite) UIView *nameView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *priceLabel;
@property (readwrite) UILabel *marketPriceLabel;
@property (readwrite) UIView *deletePriceLine;
@property (readwrite) UIButton *favoriteButton;
@property (readwrite) UIView *shippingView;
@property (readwrite) UILabel *shippingLabel;
@property (readwrite) UILabel *shippingPriceLabel;
@property (readwrite) UILabel *salesVolumeLabel;
@property (readwrite) UIView *servicesView;

@end

@implementation MLGoodsInfoCollectionViewCell

+ (CGFloat)height {
	return 160;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		CGFloat fullWidth = self.bounds.size.width;
		
		CGRect rect = CGRectZero;
		rect.size.width = fullWidth;
		rect.size.height = 90;
		_nameView = [[UIView alloc] initWithFrame:rect];
		[self.contentView addSubview:_nameView];
		
		rect.origin.y = CGRectGetMaxY(_nameView.frame);
		rect.size.height = 46;
		_shippingView = [[UIView alloc] initWithFrame:rect];
		_shippingView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1.0f];
		[self.contentView addSubview:_shippingView];
		
		rect.origin.y = CGRectGetMaxY(_shippingView.frame);
		rect.size.height = 32;
		_servicesView = [[UIView alloc] initWithFrame:rect];
		_servicesView.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0f];
		[self.contentView addSubview:_servicesView];
		
		CGFloat widthForFavoriteButton = 70;
		
		rect.origin.x = 15;
		rect.origin.y = 0;
		rect.size.width = fullWidth - widthForFavoriteButton - rect.origin.x - 10;
		rect.size.height = 42;
		_nameLabel = [[UILabel alloc] initWithFrame:rect];
		_nameLabel.numberOfLines = 0;
		_nameLabel.font = [UIFont systemFontOfSize:16];
		[_nameView addSubview:_nameLabel];
		
		rect.origin.x = CGRectGetMaxX(_nameLabel.frame) + 10;
		rect.origin.y = 10;
		rect.size.width = 1;
		rect.size.height = 40;
		UIView *line = [[UIView alloc] initWithFrame:rect];
		line.backgroundColor = [UIColor borderGrayColor];
		[self.contentView addSubview:line];
		
		rect.origin.x = CGRectGetMinX(_nameLabel.frame);
		rect.origin.y = CGRectGetMaxY(_nameLabel.frame) - 5;
		rect.size.width = 100;
		rect.size.height = 32;
		_priceLabel = [[UILabel alloc] initWithFrame:rect];
		_priceLabel.textColor = [UIColor themeColor];
		_priceLabel.font = [UIFont systemFontOfSize:22];
		[_nameView addSubview:_priceLabel];
		
		rect.origin.x = CGRectGetMaxX(_priceLabel.frame);
		rect.origin.y = CGRectGetMinY(_priceLabel.frame) + 8;
		rect.size.width = 140;
		_marketPriceLabel = [[UILabel alloc] initWithFrame:rect];
		_marketPriceLabel.textColor = [UIColor fontGrayColor];
		_marketPriceLabel.font = [UIFont systemFontOfSize:14];
		[_nameView addSubview:_marketPriceLabel];
		
		rect.origin.x = CGRectGetMinX(_marketPriceLabel.frame) + 45;
		rect.origin.y = CGRectGetMinY(_marketPriceLabel.frame) + 8;
		rect.size.width = 0;
		rect.size.height = 1;
		_deletePriceLine = [[UIView alloc] initWithFrame:rect];
		_deletePriceLine.backgroundColor = [UIColor lightGrayColor];
		[self.contentView addSubview:_deletePriceLine];
		
		UIImage *star = [UIImage imageNamed:@"Star"];
		UIImage *starHighlighted = [UIImage imageNamed:@"StarHighlighted"];
		rect.size.width = widthForFavoriteButton;
		rect.size.height = widthForFavoriteButton;
		rect.origin.x = fullWidth - rect.size.width;
		rect.origin.y = 10;
		_favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_favoriteButton.frame = rect;
		[_favoriteButton setImage:star forState:UIControlStateNormal];
		[_favoriteButton setImage:starHighlighted forState:UIControlStateSelected];
		[_favoriteButton setTitle:NSLocalizedString(@"收藏", nil) forState:UIControlStateNormal];
		[_favoriteButton setTitle:NSLocalizedString(@"已收藏", nil) forState:UIControlStateSelected];
		[_favoriteButton setTitleColor:[UIColor fontGrayColor] forState:UIControlStateNormal];
		[_favoriteButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
		_favoriteButton.titleLabel.font = [UIFont systemFontOfSize:13];
		[_favoriteButton.titleLabel sizeToFit];
		[_favoriteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -star.size.width, 0, 0)];
		[_favoriteButton setImageEdgeInsets:UIEdgeInsetsMake(-40, 0, 0, -_favoriteButton.titleLabel.bounds.size.width)];
		[_favoriteButton addTarget:self action:@selector(favorite) forControlEvents:UIControlEventTouchUpInside];
		_favoriteButton.hidden = YES;
		[_nameView addSubview:_favoriteButton];
		
		UIImage *separateLineImage = [UIImage imageNamed:@"SeparateLine"];
		UIImageView *separateLine = [[UIImageView alloc] initWithImage:separateLineImage];
		separateLine.image = separateLineImage;
		rect.origin.x = 0;
		rect.size.width = fullWidth;
		rect.size.height = separateLineImage.size.height;
		rect.origin.y = _nameView.bounds.size.height - rect.size.height;
		separateLine.frame = rect;
		[_nameView addSubview:separateLine];
		
		
		rect.origin.x = 15;
		rect.origin.y = 0;
		rect.size.width = 200;
		rect.size.height = 20;
		_shippingLabel = [[UILabel alloc] initWithFrame:rect];
		_shippingLabel.font = [UIFont systemFontOfSize:13];
		[_shippingView addSubview:_shippingLabel];
		
		rect.origin.x = 45;
		rect.origin.y = CGRectGetMaxY(_shippingLabel.frame);
		_shippingPriceLabel = [[UILabel alloc] initWithFrame:rect];
		_shippingPriceLabel.font = [UIFont systemFontOfSize:13];
		[_shippingView addSubview:_shippingPriceLabel];
		
		rect.size.width = 100;
		rect.size.height = _shippingView.frame.size.height;
		rect.origin.x = fullWidth - rect.size.width;
		rect.origin.y = 0;
		_salesVolumeLabel = [[UILabel alloc] initWithFrame:rect];
		_salesVolumeLabel.numberOfLines = 0;
		_salesVolumeLabel.textAlignment = NSTextAlignmentCenter;
		_salesVolumeLabel.font = [UIFont systemFontOfSize:13];
		[_shippingView addSubview:_salesVolumeLabel];
		
		rect.origin.x = CGRectGetMinX(_salesVolumeLabel.frame);
		rect.origin.y = 0;
		rect.size.width = 1;
		rect.size.height = 40;
		UIView *line2 = [[UIView alloc] initWithFrame:rect];
		line2.backgroundColor = [UIColor borderGrayColor];
		[_shippingView addSubview:line2];
		
		UIImage *promiseImage = [UIImage imageNamed:@"Promise"];
		rect.origin.x = 15;
		rect.origin.y = 5;
		rect.size = promiseImage.size;
		UIImageView *promiseImageView = [[UIImageView alloc] initWithFrame:rect];
		promiseImageView.image = promiseImage;
		[_servicesView addSubview:promiseImageView];
		
		rect.origin.x = CGRectGetMaxX(promiseImageView.frame) + 5;
		rect.size.width = 60;
		UILabel *promiseLabel = [[UILabel alloc] initWithFrame:rect];
		promiseLabel.text = NSLocalizedString(@"正品保证", nil);
		promiseLabel.font = [UIFont systemFontOfSize:11];
		[_servicesView addSubview:promiseLabel];
		
		
		UIImage *sevenDaysImage = [UIImage imageNamed:@"SevenDays"];
		rect.origin.x = CGRectGetMaxX(promiseLabel.frame);
		rect.size = sevenDaysImage.size;
		UIImageView *sevenDaysImageView = [[UIImageView alloc] initWithFrame:rect];
		sevenDaysImageView.image = sevenDaysImage;
		[_servicesView addSubview:sevenDaysImageView];
		
		rect.origin.x = CGRectGetMaxX(sevenDaysImageView.frame) + 5;
		rect.size.width = 120;
		UILabel *sevenDaysLabel = [[UILabel alloc] initWithFrame:rect];
		sevenDaysLabel.font = [UIFont systemFontOfSize:11];
		sevenDaysLabel.text = NSLocalizedString(@"七天无理由退货", nil);
		[_servicesView addSubview:sevenDaysLabel];
	}
	return self;
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
	if (_goods) {
		_nameLabel.text = _goods.name;
		if (_goods.VIPPrice) {
			_priceLabel.text = [NSString stringWithFormat:@"¥%.2f", _goods.VIPPrice.floatValue];
		}
		if (_goods.marketPrice) {
			_marketPriceLabel.text = [NSString stringWithFormat:@"市场价:¥%0.2f", _goods.marketPrice.floatValue];
			[_marketPriceLabel sizeToFit];
			CGRect rect = _deletePriceLine.frame;
			rect.size.width = _marketPriceLabel.frame.size.width - 45;
			_deletePriceLine.frame = rect;
		}
		_favoriteButton.hidden = NO;
		_favoriteButton.selected = _goods.favorited.boolValue;
		[_favoriteButton.titleLabel sizeToFit];
		[_favoriteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_favoriteButton.imageView.image.size.width, 0, 0)];
		[_favoriteButton setImageEdgeInsets:UIEdgeInsetsMake(-40, 0, 0, -_favoriteButton.titleLabel.bounds.size.width)];
		_salesVolumeLabel.text = [NSString stringWithFormat:@"销量\n%@", _goods.salesVolume];
		if (_goods.goodsFrom && _goods.goodsTo) {
			_shippingLabel.text = [NSString stringWithFormat:@"%@ 至 %@", _goods.goodsFrom, _goods.goodsTo];
		}
		if (_goods.postage && _goods.postageWay) {
			_shippingPriceLabel.text = [NSString stringWithFormat:@"%@:%@", _goods.postageWay, _goods.postage];
		}
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_nameLabel.text = nil;
	_priceLabel.text = nil;
	_marketPriceLabel.text = nil;
//	_shippingLabel.text = nil;
//	_shippingPriceLabel.text = nil;
//	_salesVolumeLabel.text = nil;
	_favoriteButton.hidden = YES;
}

- (void)favorite {
	if (_delegate) {
		[_delegate goods:_goods farovite:!_favoriteButton.selected];
	}
}

@end
