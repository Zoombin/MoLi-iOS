//
//  MLHotStoresCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/27/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLHotStoresCollectionViewCell.h"
#import "Header.h"

@interface MLHotStoresCollectionViewCell ()

@property (readwrite) UIImageView *storeViewFirst;
@property (readwrite) UIImageView *storeViewSecond;
@property (readwrite) UIImageView *storeViewThird;

@end

@implementation MLHotStoresCollectionViewCell

+ (CGFloat)height {
	return 182;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 8, 4, 8);
		CGRect rect = CGRectZero;
		rect.size.width = self.bounds.size.width;
		rect.size.height = 0.5;
		[self.contentView addSubview:[UIView borderLineWithFrame:rect]];
		
		rect = CGRectMake(edgeInsets.left, 0, [UIScreen mainScreen].bounds.size.width - edgeInsets.left - edgeInsets.right, 40);
		UILabel *label = [[UILabel alloc] initWithFrame:rect];
		label.text = @"热门商家";
		label.textColor = [UIColor fontGrayColor];
		label.font = [UIFont systemFontOfSize:15];
		[self.contentView addSubview:label];
		
		rect.origin.y = CGRectGetMaxY(label.frame) - 8;
		rect.size.width = ([UIScreen mainScreen].bounds.size.width - edgeInsets.left * 3) / 2;
		rect.size.height = 142;
		_storeViewFirst = [[UIImageView alloc] initWithFrame:rect];
		_storeViewFirst.userInteractionEnabled = YES;
		[self.contentView addSubview:_storeViewFirst];
		
		rect.origin.x = CGRectGetMaxX(_storeViewFirst.frame) + edgeInsets.right;
		rect.size.height = (rect.size.height - edgeInsets.bottom) / 2;
		_storeViewSecond = [[UIImageView alloc] initWithFrame:rect];
		_storeViewSecond.userInteractionEnabled = YES;
		[self.contentView addSubview:_storeViewSecond];
		
		rect.origin.y = CGRectGetMaxY(_storeViewSecond.frame) + edgeInsets.bottom;
		_storeViewThird = [[UIImageView alloc] initWithFrame:rect];
		_storeViewThird.userInteractionEnabled = YES;
		[self.contentView addSubview:_storeViewThird];
		
		rect.size.width = self.bounds.size.width;
		rect.size.height = 0.5;
		rect.origin.x = 0;
		rect.origin.y = [[self class] height] - 0.5;
		[self.contentView addSubview:[UIView borderLineWithFrame:rect]];
		
		UITapGestureRecognizer *tapFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[_storeViewFirst addGestureRecognizer:tapFirst];
		
		UITapGestureRecognizer *tapSecond = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[_storeViewSecond addGestureRecognizer:tapSecond];
		
		UITapGestureRecognizer *tapThird = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[_storeViewThird addGestureRecognizer:tapThird];
	}
	return self;
}

- (void)setAdvertisements:(NSArray *)advertisements {
	_advertisements = advertisements;
	for (int i = 0; i < _advertisements.count; i++) {
		MLAdvertisement *advertisement = _advertisements[i];
		MLAdvertisementElement *element = advertisement.elements[0];
		
		UIImageView *imageView = nil;
		if (i == 0) {
			imageView = _storeViewFirst;
		} else if (i == 1) {
			imageView = _storeViewSecond;
		} else {
			imageView = _storeViewThird;
		}
		if (element) [imageView setImageWithURL:[NSURL URLWithString:element.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
	}
}

- (void)tapped:(UITapGestureRecognizer *)tap {
	MLAdvertisement *ad = nil;
	if (tap.view == _storeViewFirst) {
		ad = _advertisements[0];
	} else if (tap.view == _storeViewSecond) {
		ad = _advertisements[1];
	} else {
		ad = _advertisements[2];
	}
	if (self.delegate) {
		[self.delegate collectionViewCellWillSelectAdvertisement:ad advertisementElement:ad.elements[0]];
	}
}


@end
