//
//  MLGoodsPropertyCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/19/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGoodsPropertyCollectionViewCell.h"
#import "Header.h"

@interface MLGoodsPropertyCollectionViewCell ()

@property (readwrite) UILabel *valueLabel;
@property (readwrite) MLGoodsProperty *goodsProperty;
@property (readwrite) NSIndexPath *indexPath;

@end

@implementation MLGoodsPropertyCollectionViewCell

+ (CGFloat)height {
	return 30;
}

+ (CGFloat)minimumWidth {
	return 60;
}

+ (CGFloat)maximumWidth {
	return 260;
}

+ (CGFloat)widthForText:(NSString *)text {
//	if (text.length < 5) {
//		return [self minimumWidth];
//	} else if (text.length < 15) {
//		return 130;
//	}
	return [self minimumWidth];
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.layer.borderWidth = 0.5;
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		
		_valueLabel = [[UILabel alloc] initWithFrame:self.bounds];
		_valueLabel.font = [UIFont systemFontOfSize:13];
		_valueLabel.adjustsFontSizeToFitWidth = YES;
		_valueLabel.textColor = [UIColor lightGrayColor];
		_valueLabel.textAlignment = NSTextAlignmentCenter;
		[self.contentView addSubview:_valueLabel];
	}
	return self;
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	UIColor *backgroundColor = selected ? [UIColor themeColor] : [UIColor whiteColor];
	UIColor *fontColor = selected ? [UIColor whiteColor] : [UIColor lightGrayColor];
	_valueLabel.backgroundColor = backgroundColor;
	_valueLabel.textColor = fontColor;
}

- (void)setGoodsProperty:(MLGoodsProperty *)goodsProperty atIndexPath:(NSIndexPath *)indexPath {
	_goodsProperty = goodsProperty;
	_indexPath = indexPath;
	if (_goodsProperty && _indexPath) {
		_valueLabel.text = _goodsProperty.values[indexPath.row];
	}
}

@end
