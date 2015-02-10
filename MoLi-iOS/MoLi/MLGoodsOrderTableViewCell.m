//
//  MLGoodsOrderTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/30/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoodsOrderTableViewCell.h"
#import "Header.h"


@implementation MLGoodsOrderTableViewCell

+ (CGFloat)height {
	return 84;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.textLabel.numberOfLines = 2;
		self.textLabel.adjustsFontSizeToFitWidth = YES;
		self.textLabel.font = [UIFont systemFontOfSize:16];
		self.textLabel.textColor = [UIColor fontGrayColor];
		self.detailTextLabel.textColor = [UIColor fontGrayColor];
		self.imageView.layer.borderWidth = 0.5;
		self.imageView.layer.borderColor = [[UIColor borderGrayColor] CGColor];
	}
	return self;
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
	if (_goods) {
		[self.imageView setImageWithURL:[NSURL URLWithString:_goods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		self.textLabel.text = _goods.name;
		self.detailTextLabel.text = [NSString stringWithFormat:@"价格:¥%@      数量:%@", _goods.price, _goods.quantityBought];
	}
}

@end
