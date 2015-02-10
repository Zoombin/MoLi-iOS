//
//  MLGoodsNormalCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/30/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGoodsNormalCollectionViewCell.h"
#import "Header.h"

@interface MLGoodsNormalCollectionViewCell ()

@property (readwrite) UIImageView *imageView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *priceLabel;
@property (readwrite) UILabel *salesLabel;
@property (readwrite) UILabel *highOpinionLabel;

@end

@implementation MLGoodsNormalCollectionViewCell

+ (CGFloat)height {
	return 94;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(15, 5, 5, 15);
		CGRect rect = CGRectZero;
		rect.size.width = [[self class] height];
		rect.size.height = rect.size.width;
		_imageView = [[UIImageView alloc] initWithFrame:rect];
		[self.contentView addSubview:_imageView];
		
		rect.origin.x = CGRectGetMaxX(_imageView.frame) + edgeInsets.left;
		rect.size.width = self.bounds.size.width - rect.origin.x - edgeInsets.right;
		rect.size.height = 50;
		_nameLabel = [[UILabel alloc] initWithFrame:rect];
		_nameLabel.font = [UIFont systemFontOfSize:16];
		_nameLabel.textColor = [UIColor fontGrayColor];
		_nameLabel.numberOfLines = 0;
		[self.contentView addSubview:_nameLabel];
		
		rect.size.width = 35;
		rect.size.height = 20;
		rect.origin.y = CGRectGetMaxY(_nameLabel.frame);
		UILabel *label = [[UILabel alloc] initWithFrame:rect];
		label.text = @"价格:";
		label.font = [UIFont systemFontOfSize:13];
		label.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:label];
		
		rect.origin.x = CGRectGetMaxX(label.frame);
		rect.size.width = self.bounds.size.width - rect.origin.x - edgeInsets.right;
		_priceLabel = [[UILabel alloc] initWithFrame:rect];
		_priceLabel.font = [UIFont systemFontOfSize:15];
		_priceLabel.textColor = [UIColor themeColor];
		[self.contentView addSubview:_priceLabel];
		
		rect.origin.x = CGRectGetMinX(_nameLabel.frame);
		rect.origin.y = CGRectGetMaxY(label.frame);
		rect.size.width = 132;
		_salesLabel = [[UILabel alloc] initWithFrame:rect];
		_salesLabel.font = label.font;
		_salesLabel.textColor = label.textColor;
		[self.contentView addSubview:_salesLabel];
		
		_highOpinionLabel = [[UILabel alloc] initWithFrame:rect];
		_highOpinionLabel.font = _salesLabel.font;
		_highOpinionLabel.textColor = _salesLabel.textColor;
		_highOpinionLabel.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:_highOpinionLabel];
		
		rect.origin.x = 0;
		rect.origin.y = [[self class] height] - 0.5;
		rect.size.width = self.bounds.size.width;
		rect.size.height = 0.5;
		UIView *line = [[UIView alloc] initWithFrame:rect];
		line.backgroundColor = [UIColor lightGrayColor];
		[self.contentView addSubview:line];
	}
	return self;
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
	if (_goods) {
		[_imageView setImageWithURL:[NSURL URLWithString:_goods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		_nameLabel.text = _goods.name;
		_priceLabel.text = [NSString stringWithFormat:@"¥%@", _goods.price];
		_salesLabel.text = [NSString stringWithFormat:@"销量:%@", _goods.salesVolume];
		_highOpinionLabel.text = [NSString stringWithFormat:@"好评率:%@", _goods.highOpinion];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_imageView.image = nil;
	_nameLabel.text = nil;
	_salesLabel.text = nil;
	_highOpinionLabel.text = nil;
}

@end
