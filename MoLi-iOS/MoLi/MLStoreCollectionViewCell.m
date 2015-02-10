//
//  MLStoreCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/27/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLStoreCollectionViewCell.h"
#import "Header.h"

@interface MLStoreCollectionViewCell ()

@property (readwrite) UIImageView *imageView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *businessCategoryLabel;
@property (readwrite) UILabel *addressLabel;
@property (readwrite) UIImageView *businessCategoryIconView;

@end

@implementation MLStoreCollectionViewCell

+ (CGFloat)height {
	return 90;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(15, ML_COMMON_EDGE_LEFT, 15, ML_COMMON_EDGE_LEFT);
		CGRect rect = CGRectZero;
		
		rect.origin.x = edgeInsets.left;
		rect.origin.y = edgeInsets.top;
		rect.size.width = 62;
		rect.size.height = rect.size.width;
		_imageView = [[UIImageView alloc] initWithFrame:rect];
		_imageView.layer.borderColor = [[UIColor borderGrayColor] CGColor];
		_imageView.layer.borderWidth = 0.5;
		[self.contentView addSubview:_imageView];
		
		rect.origin.x = 90;
		rect.origin.y = 0;
		rect.size.width = [UIScreen mainScreen].bounds.size.width - rect.origin.x - edgeInsets.right;
		rect.size.height = 50;
		
		_nameLabel = [[UILabel alloc] initWithFrame:rect];
		_nameLabel.numberOfLines = 0;
		_nameLabel.textColor = [UIColor lightGrayColor];
		[self.contentView addSubview:_nameLabel];
		
		rect.origin.y = CGRectGetMaxY(_nameLabel.frame);
		rect.size.width = 16;
		rect.size.height = rect.size.width;
		_businessCategoryIconView = [[UIImageView alloc] initWithFrame:rect];
		_businessCategoryIconView.contentMode = UIViewContentModeCenter;
		[self.contentView addSubview:_businessCategoryIconView];
		
		rect.origin.x = CGRectGetMaxX(_businessCategoryIconView.frame);
		rect.size.width = self.bounds.size.width - rect.origin.x - edgeInsets.right;
		_businessCategoryLabel = [[UILabel alloc] initWithFrame:rect];
		_businessCategoryLabel.font = [UIFont systemFontOfSize:11];
		_businessCategoryLabel.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:_businessCategoryLabel];
		
		rect.origin.x = CGRectGetMinX(_businessCategoryIconView.frame);
		rect.origin.y = CGRectGetMaxY(_businessCategoryIconView.frame) + 2;
		rect.size = _businessCategoryIconView.frame.size;
		UIImageView *addressIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Location"]];
		addressIconView.contentMode = UIViewContentModeCenter;
		addressIconView.frame = rect;
		[self.contentView addSubview:addressIconView];
		
		rect.origin.x = CGRectGetMaxX(addressIconView.frame);
		rect.size.width = self.bounds.size.width - rect.origin.x - edgeInsets.right;
		_addressLabel = [[UILabel alloc] initWithFrame:rect];
		_addressLabel.font = [UIFont systemFontOfSize:11];
		_addressLabel.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:_addressLabel];
		
		rect.size.width = self.bounds.size.width - edgeInsets.left - edgeInsets.right;
		rect.size.height = 0.5;
		rect.origin.x = edgeInsets.left;
		rect.origin.y = [[self class] height] - rect.size.height;
		[self.contentView addSubview:[UIView borderLineWithFrame:rect]];
//		CGPoint start = CGPointMake(15, [[self class] height] - 0.5);
//		CGPoint end = CGPointMake(self.bounds.size.width - edgeInsets.left - edgeInsets.right, start.y);
//		[self dashedLineStart:start end:end];
	}
	return self;
}

- (void)setStore:(MLStore *)store {
	_store = store;
	if (_store) {
		[_imageView setImageWithURL:[NSURL URLWithString:_store.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		_nameLabel.text = _store.name;
		_businessCategoryLabel.text = _store.businessCategory;
		_addressLabel.text = _store.address;
		_businessCategoryIconView.image = [MLStore imageByStoreCategory:_store.businessCategory];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_imageView.image = nil;
	_nameLabel.text = nil;
	_businessCategoryLabel.text = nil;
	_addressLabel.text = nil;
}

- (void)dashedLineStart:(CGPoint)start end:(CGPoint)end {
	CGContextRef context =UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	CGContextSetLineWidth(context, 0.5);
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGFloat lengths[] = {10, 10};
	CGContextSetLineDash(context, 0, lengths, 2);
	CGContextMoveToPoint(context, start.x, start.y);
	CGContextAddLineToPoint(context, end.x, end.y);
	CGContextStrokePath(context);
	CGContextClosePath(context);
}


@end
