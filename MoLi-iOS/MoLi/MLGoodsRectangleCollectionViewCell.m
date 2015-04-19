//
//  MLGoodsRectangleCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/20/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGoodsRectangleCollectionViewCell.h"
#import "Header.h"

@interface MLGoodsRectangleCollectionViewCell ()

@property (nonatomic, readwrite) UIImageView *imageView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *priceLabel;

@end

@implementation MLGoodsRectangleCollectionViewCell

+ (CGFloat)height {
	return 110;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		CGRect rect = CGRectZero;
		rect.origin.x = 35;
		rect.origin.y = 15;
		rect.size.width = 80;
		rect.size.height = rect.size.width;
		_imageView = [[UIImageView alloc] initWithFrame:rect];
		[self.contentView addSubview:_imageView];
		
		rect.origin.x = CGRectGetMaxX(_imageView.frame) + 5;
		rect.origin.y = 13;
		rect.size.width = 280 - rect.origin.x;
		rect.size.height = 60;
		_nameLabel = [[UILabel alloc] initWithFrame:rect];
		_nameLabel.numberOfLines = 0;
		_nameLabel.font = [UIFont systemFontOfSize:13];
		_nameLabel.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:_nameLabel];
		
		rect.origin.y = CGRectGetMaxY(_nameLabel.frame);
		rect.size.height = 30;
		UILabel *label = [[UILabel alloc] initWithFrame:rect];
		label.text = @"金额:";
		label.font = [UIFont systemFontOfSize:13];
		[self.contentView addSubview:label];
		
		rect.origin.x = CGRectGetMaxX(_imageView.frame) + 40;
		_priceLabel = [[UILabel alloc] initWithFrame:rect];
		_priceLabel.font = [UIFont systemFontOfSize:16];
		_priceLabel.textColor = [UIColor themeColor];
		[self.contentView addSubview:_priceLabel];
	}
	return self;
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
	if (_goods) {
		NSString *imagePath = _goods.logo;
		if (!imagePath) {
			imagePath = _goods.imagePath;
		}
		[_imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		_nameLabel.text = _goods.name;
		_priceLabel.text = [NSString stringWithFormat:@"¥%.2f", _goods.VIPPrice.floatValue];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_imageView.image = nil;
	_nameLabel.text = nil;
	_priceLabel.text = nil;
}



@end
