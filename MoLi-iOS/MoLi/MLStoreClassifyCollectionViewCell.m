//
//  MLStoreClassifyCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/29/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLStoreClassifyCollectionViewCell.h"
#import "Header.h"

@interface MLStoreClassifyCollectionViewCell ()

@property (readwrite) UIImageView *imageView;
@property (readwrite) UILabel *label;

@end

@implementation MLStoreClassifyCollectionViewCell

+ (CGSize)size {
	return CGSizeMake(90, 90);
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self.contentView addSubview:_imageView];
		
		_label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 24, self.bounds.size.width, 24)];
		_label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
		_label.textColor = [UIColor whiteColor];
		_label.adjustsFontSizeToFitWidth = YES;
		_label.textAlignment = NSTextAlignmentCenter;
		[self.contentView addSubview:_label];
	}
	return self;
}

- (void)setStoreClassify:(MLStoreClassify *)storeClassify {
	_storeClassify = storeClassify;
	if (_storeClassify) {
		[_imageView setImageWithURL:[NSURL URLWithString:_storeClassify.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		_label.text = _storeClassify.name;
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_imageView.image = nil;
	_label.text = nil;
}

@end
