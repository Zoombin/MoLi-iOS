//
//  MLChoiceCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/24/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLNormalCollectionViewCell.h"
#import "Header.h"

@interface MLNormalCollectionViewCell ()

@property (readwrite) UIImageView *imageView;

@end

@implementation MLNormalCollectionViewCell

+ (CGSize)smallStyleSize {
	return CGSizeMake(140, 80);
}

+ (CGSize)size {
	return CGSizeMake(290, 138);
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[_imageView addGestureRecognizer:tap];
		[self.contentView addSubview:_imageView];
	}
	return self;
}

- (void)setAdvertisementElement:(MLAdvertisementElement *)advertisementElement {
	[super setAdvertisementElement:advertisementElement];
	if (!self.advertisementElement) return;

	NSString *placeholderName = @"AdvertisementNormalPlaceholder";
	if (self.bounds.size.height < [[self class] size].height) {
		placeholderName = @"AdvertisementNormalSmallPlaceholder";
	}
	[_imageView setImageWithURL:[NSURL URLWithString:self.advertisementElement.imagePath] placeholderImage:[UIImage imageNamed:placeholderName]];
}

- (void)tapped:(UITapGestureRecognizer *)tap {
	if (self.delegate) {
		[self.delegate collectionViewCellWillSelectAdvertisement:self.advertisement advertisementElement:self.advertisementElement];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_imageView.image = nil;
}

@end
