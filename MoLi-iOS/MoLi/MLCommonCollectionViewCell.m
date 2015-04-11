//
//  MLCommonCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/9/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLCommonCollectionViewCell.h"
#import "Header.h"

@implementation MLCommonCollectionViewCell

+ (CGFloat)height {
	return 46;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		UIView *topLine = [UIView borderLineWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
		[self.contentView addSubview:topLine];
		
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[self class] height], [[self class] height])];
		_imageView.contentMode = UIViewContentModeCenter;
		[self.contentView addSubview:_imageView];
		
		_label = [[UILabel alloc] initWithFrame:CGRectMake(ML_COMMON_EDGE_LEFT, 0, self.bounds.size.width - ML_COMMON_EDGE_LEFT - ML_COMMON_EDGE_RIGHT, self.bounds.size.height)];
		_label.font = [UIFont systemFontOfSize:13];
		_label.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:_label];
		
		UIView *bottomLine = [UIView borderLineWithFrame:CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5)];
		[self.contentView addSubview:bottomLine];
        
        _imagedirection = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-15-23, (CGRectGetHeight(frame)-23)/2, 23, 23)];
        [_imagedirection setImage:[UIImage imageNamed:@"lightarricon"]];
        [self addSubview:_imagedirection];
        _imagedirection.hidden = YES;
	}
	return self;
}

- (void)setText:(NSString *)text {
	_text = text;
	_label.text = _text;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
	_attributedText = attributedText;
	_label.attributedText = _attributedText;
}

- (void)setImage:(UIImage *)image {
	_image = image;
	_imageView.image = _image;
	CGRect frame = _label.frame;
	frame.origin.x = CGRectGetMaxX(_imageView.frame) - 10;
	_label.frame = frame;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_imageView.image = nil;
	_label.text = nil;
	_label.attributedText = nil;
}

@end
