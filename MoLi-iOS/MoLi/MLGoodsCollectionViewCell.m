//
//  MLGoodsCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/9/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGoodsCollectionViewCell.h"
#import "Header.h"

@interface MLGoodsCollectionViewCell ()

@property (readwrite) UIImageView *imageView;
@property (readwrite) UIImageView *flagView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *priceLabel;
@property (readwrite) UILabel *salesLabel;
@property (readwrite) UILabel *highOpinionLabel;

@end

@implementation MLGoodsCollectionViewCell

+ (CGFloat)height {
	return 224;
}

+ (CGSize)size {
	return CGSizeMake(146, [self height]);
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.layer.borderWidth = 0.5;
		self.layer.borderColor = [[UIColor borderGrayColor] CGColor];
		self.backgroundColor = [UIColor whiteColor];
		CGRect rect = CGRectZero;
		rect.size.width = self.bounds.size.width;
		rect.size.height = rect.size.width;
		
		_imageView = [[UIImageView alloc] initWithFrame:rect];
		[self.contentView addSubview:_imageView];
		
		UIImage *flag = [UIImage imageNamed:@"Voucher"];
		rect.origin.x = 119;
		rect.origin.y = 0;
		rect.size = flag.size;
		_flagView = [[UIImageView alloc] initWithFrame:rect];
		_flagView.image = flag;
		_flagView.hidden = YES;
		[self.contentView addSubview:_flagView];
		
		rect.origin.x = 5;
		rect.origin.y = CGRectGetMaxY(_imageView.frame);
		rect.size.width = self.bounds.size.width - 2 * rect.origin.x;
		rect.size.height = 32;
		_nameLabel = [[UILabel alloc] initWithFrame:rect];
		_nameLabel.numberOfLines = 0;
		_nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
		_nameLabel.font = [UIFont systemFontOfSize:13];
		_nameLabel.textColor = [UIColor lightGrayColor];
		[self.contentView addSubview:_nameLabel];
		
		rect.origin.y = CGRectGetMaxY(_nameLabel.frame);
		rect.size.height = 20;
		UILabel *label = [[UILabel alloc] initWithFrame:rect];
		label.text = NSLocalizedString(@"价格:", nil);
		label.font = [UIFont systemFontOfSize:10];
		label.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:label];
		
		rect.origin.x = 34;
		_priceLabel = [[UILabel alloc] initWithFrame:rect];
		_priceLabel.textColor = [UIColor redColor];
		_priceLabel.font = [UIFont systemFontOfSize:14];
		[self.contentView addSubview:_priceLabel];
		
		rect.origin.x = 5;
		rect.origin.y = CGRectGetMaxY(label.frame) - 5;
		rect.size.width = self.bounds.size.width - 2 * rect.origin.x;
		_salesLabel = [[UILabel alloc] initWithFrame:rect];
		_salesLabel.textColor = [UIColor fontGrayColor];
		_salesLabel.font = [UIFont systemFontOfSize:10];
		[self.contentView addSubview:_salesLabel];
		
		_highOpinionLabel = [[UILabel alloc] initWithFrame:rect];
		_highOpinionLabel.textColor = [UIColor fontGrayColor];
		_highOpinionLabel.font = [UIFont systemFontOfSize:10];
		_highOpinionLabel.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:_highOpinionLabel];
	}
	return self;
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
	if (_goods) {
		[_imageView setImageWithURL:[NSURL URLWithString:_goods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		_flagView.hidden = ![_goods voucherValid];
		_nameLabel.text = _goods.name;
		_priceLabel.text = [NSString stringWithFormat:@"¥%0.2f", _goods.price.floatValue];
		_salesLabel.text = [NSString stringWithFormat:@"销量:%@", _goods.salesVolume];
		_highOpinionLabel.text = [NSString stringWithFormat:@"好评率:%@％",  _goods.highOpinion];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_imageView.image = nil;
	_nameLabel.text = nil;
	_priceLabel.text = nil;
	_salesLabel.text = nil;
	_highOpinionLabel.text = nil;
}

@end
