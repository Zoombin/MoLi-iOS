//
//  MLCategoryTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 2/10/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLCategoryTableViewCell.h"
#import "Header.h"

@interface MLCategoryTableViewCell ()

@property (readwrite) UIImageView *iconView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *captionLabel;

@end

@implementation MLCategoryTableViewCell

+ (CGFloat)height {
	return 70;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		CGRect rect = CGRectZero;
		rect.size.width = rect.size.height = 52;
		rect.origin.x = ML_COMMON_EDGE_LEFT;
		rect.origin.y = ([[self class] height] - rect.size.height) / 2;
		_iconView = [[UIImageView alloc] initWithFrame:rect];
		_iconView.clipsToBounds = YES;
        _iconView.layer.masksToBounds = YES;
		_iconView.layer.cornerRadius = _iconView.frame.size.height/2;
//		_iconView.contentMode = UIViewContentModeScaleAspectFit;
//        _iconView.layer.shadowColor = [UIColor redColor].CGColor;
//        _iconView.layer.shadowOffset = CGSizeMake(4.0, 4.0);
//        _iconView.layer.shadowOpacity = 0.5;
//        _iconView.layer.shadowRadius = 2.0;
//        _iconView.layer.borderColor = [UIColor orangeColor].CGColor;
//        _iconView.layer.borderWidth = 2.0f;
		[self.contentView addSubview:_iconView];
		
		rect.origin.x = CGRectGetMaxX(_iconView.frame) + 15;
		rect.origin.y = 10;
		rect.size.width = fullWidth - rect.origin.x;
		rect.size.height = 32;
		_nameLabel = [[UILabel alloc] initWithFrame:rect];
		_nameLabel.font = [UIFont systemFontOfSize:17];
		[self.contentView addSubview:_nameLabel];
		
		rect.origin.y = CGRectGetMaxY(_nameLabel.frame) - 6;
		rect.size.height = 20;
		_captionLabel = [[UILabel alloc] initWithFrame:rect];
		_captionLabel.font = [UIFont systemFontOfSize:12];
		_captionLabel.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:_captionLabel];
	}
	return self;
}

- (void)setGoodsClassify:(MLGoodsClassify *)goodsClassify {
	_goodsClassify = goodsClassify;
	if (_goodsClassify) {
		[_iconView setImageWithURL:[NSURL URLWithString:_goodsClassify.iconPath]];
		_nameLabel.text = _goodsClassify.name;
		_captionLabel.text = _goodsClassify.caption;
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_iconView.image = nil;
	_nameLabel.text = nil;
	_captionLabel.text = nil;
}

- (void)drawRect:(CGRect)rect {
	CGFloat lengths[] = {10, 5};
	CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1] set];
	CGContextSetLineDash(context, 0, lengths, 2);
	CGContextMoveToPoint(context, 10.0, [MLCategoryTableViewCell height] - 2);
	CGContextAddLineToPoint(context, WINSIZE.width - 20, [MLCategoryTableViewCell height] - 2);
	CGContextStrokePath(context);
	
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGFloat dashLengths[] = { 10, 5 };
//	CGContextSetLineDash(context, 0, dashLengths, 2);
}

@end
