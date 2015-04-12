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
@property (readwrite) UIImageView *flagView;

@end

@implementation MLGoodsNormalCollectionViewCell

+ (CGFloat)height {
	return 99;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
		CGRect rect = CGRectZero;
		rect.origin.x = edgeInsets.left;
		rect.origin.y = edgeInsets.top;
		rect.size.width = 78;
		rect.size.height = rect.size.width;
		_imageView = [[UIImageView alloc] initWithFrame:rect];
		_imageView.layer.borderColor = [[UIColor borderGrayColor] CGColor];
		_imageView.layer.borderWidth = 0.5;
		[self.contentView addSubview:_imageView];
		
		rect.origin.x = CGRectGetMaxX(_imageView.frame) + edgeInsets.left;
		rect.origin.y = 0;
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
		
		UIImage *flag = [UIImage imageNamed:@"Voucher"];
		rect.origin.x = [UIScreen mainScreen].bounds.size.width - 40;
		rect.origin.y += 5;
		rect.size = flag.size;
		_flagView = [[UIImageView alloc] initWithFrame:rect];
		_flagView.image = flag;
		_flagView.hidden = YES;
		[self.contentView addSubview:_flagView];
		
		rect.origin.x = 0;
		rect.origin.y = [[self class] height] - 0.5;
		rect.size.width = self.bounds.size.width;
		rect.size.height = 0.5;
		UIView *line = [[UIView alloc] initWithFrame:rect];
		line.backgroundColor = [UIColor borderGrayColor];
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
		_highOpinionLabel.text = [NSString stringWithFormat:@"好评率:%@％", _goods.highOpinion];
		_flagView.hidden = ![_goods voucherValid];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_imageView.image = nil;
	_nameLabel.text = nil;
	_salesLabel.text = nil;
	_highOpinionLabel.text = nil;
	_flagView.hidden = YES;
}

@end
