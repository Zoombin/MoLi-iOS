//
//  MLUploadedImageView.m
//  MoLi
//
//  Created by zhangbin on 2/2/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLUploadedImageView.h"

@interface MLUploadedImageView ()

@property (readwrite) UIImageView *imageView;

@end

@implementation MLUploadedImageView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		_imageView.userInteractionEnabled = YES;
		[self addSubview:_imageView];
		
		UIImage *deleteImage = [UIImage imageNamed:@"DeleteUploadedImage"];
		UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, deleteImage.size.width, deleteImage.size.height)];
		deleteImageView.image = deleteImage;
		deleteImageView.center = CGPointMake(CGRectGetMaxX(_imageView.bounds), 0);
		[_imageView addSubview:deleteImageView];
	}
	return self;
}

- (void)setImage:(UIImage *)image {
	_image = image;
	if (_image) {
		_imageView.image = _image;
	}
}

@end
