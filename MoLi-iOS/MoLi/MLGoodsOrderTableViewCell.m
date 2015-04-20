//
//  MLGoodsOrderTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/30/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoodsOrderTableViewCell.h"
#import "Header.h"

@interface MLGoodsOrderTableViewCell()

@property (readwrite) UIImageView *iconView;
@property (readwrite) VerticallyAlignedLabel *nameLabel;
@property (readwrite) UILabel *priceLabel;
@property (readwrite) UILabel *numberLabel;
@property (readwrite) UILabel *propertiesLabel;

@end

@implementation MLGoodsOrderTableViewCell

+ (CGFloat)height {
	return 80;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, WINSIZE.width - 20, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.contentView addSubview:line];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
        _iconView.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
        _iconView.layer.borderWidth = 0.5;
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconView];
        
        float x = _iconView.x + _iconView.width + 10;
        float width = WINSIZE.width - x - 20;
        
        _nameLabel = [[VerticallyAlignedLabel alloc] init];
        [_nameLabel setVerticalAlignment:VerticalAlignmentTop];
        _nameLabel.frame = CGRectMake(x, _iconView.frame.origin.y, width, 20);
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1];
        [self.contentView addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.frame = CGRectMake(x, CGRectGetMaxY(_nameLabel.frame) + 2, width, 15);
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
        [self.contentView addSubview:_priceLabel];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.frame = CGRectMake(self.frame.size.width - 120, _priceLabel.frame.origin.y, 100, 15);
		_numberLabel.font = _priceLabel.font;
        _numberLabel.textAlignment = NSTextAlignmentRight;
        _numberLabel.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
        [self.contentView addSubview:_numberLabel];
		
		_propertiesLabel = [[UILabel alloc] init];
		_propertiesLabel.frame = CGRectMake(x, CGRectGetMaxY(_priceLabel.frame) + 2, width, 15);
		_propertiesLabel.font = _numberLabel.font;
		_propertiesLabel.textColor = _numberLabel.textColor;
		[self.contentView addSubview:_propertiesLabel];
    }
    return self;
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
    if (_goods) {
        [_iconView setImageWithURL:[NSURL URLWithString:goods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
        _priceLabel.text = [NSString stringWithFormat:@"价格:¥%0.2f", [_goods.price floatValue]];
        _numberLabel.text = [NSString stringWithFormat:@"数量:%@", _goods.quantityBought];
        _nameLabel.text = _goods.name;
        [_nameLabel sizeToFit];
        
        float x = _iconView.x + _iconView.width + 10;
        float width = WINSIZE.width - x - 20;
        _priceLabel.frame = CGRectMake(x, CGRectGetMaxY(_nameLabel.frame) + 2, width, 15);
        _numberLabel.frame = CGRectMake(self.frame.size.width - 120, _priceLabel.frame.origin.y, 100, 15);
        _propertiesLabel.frame = CGRectMake(x, CGRectGetMaxY(_priceLabel.frame) + 2, width, 15);

		_propertiesLabel.text = _goods.goodsPropertiesString;
	}
}

@end
