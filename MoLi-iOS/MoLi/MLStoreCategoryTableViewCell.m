//
//  MLStoreCategoryTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLStoreCategoryTableViewCell.h"
#import "Header.h"

@interface MLStoreCategoryTableViewCell ()

@property (readwrite) UIButton *foodButton;
@property (readwrite) UIButton *funButton;
@property (readwrite) UIButton *lifeButton;
@property (readwrite) UIButton *allButton;

@end

@implementation MLStoreCategoryTableViewCell

+ (CGFloat)height {
	return 90;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		UIEdgeInsets titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0);
		UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(-15, 0, 0, 0);
		UIFont *font = [UIFont systemFontOfSize:13];
		
		CGRect frame = CGRectZero;
		frame.size.width = [UIScreen mainScreen].bounds.size.width / 4;
		frame.size.height = [[self class] height];
		
#warning image wrong
		UIImage *foodImage = [UIImage imageNamed:@"StoreFood"];
		UIImage *foodImageSelected = [UIImage imageNamed:@"StoreFoodSelected"];
		_foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_foodButton.frame = frame;
		[_foodButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
		[_foodButton setTitle:NSLocalizedString(@"美食", nil) forState:UIControlStateNormal];
		_foodButton.titleLabel.font = font;
		[_foodButton.titleLabel sizeToFit];
		[_foodButton setImage:foodImage forState:UIControlStateNormal];
		[_foodButton setImage:foodImageSelected forState:UIControlStateSelected];
		_foodButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsets.top, -foodImage.size.width, 0, 0);
		_foodButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsets.top, 0, 0, -_foodButton.titleLabel.bounds.size.width);
		
		frame.origin.x = CGRectGetMaxX(_foodButton.frame);
		_funButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_funButton.frame = frame;
		[_funButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
		[_funButton setTitle:NSLocalizedString(@"休闲娱乐", nil) forState:UIControlStateNormal];
		_funButton.titleLabel.font = font;
		[_funButton.titleLabel sizeToFit];
		[_funButton setImage:[UIImage imageNamed:@"StoreFun"] forState:UIControlStateNormal];
		[_funButton setImage:[UIImage imageNamed:@"StoreFunSelected"] forState:UIControlStateSelected];
		_funButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsets.top, -foodImage.size.width, 0, 0);
		_funButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsets.top, 0, 0, -_funButton.titleLabel.bounds.size.width);
		
		frame.origin.x = CGRectGetMaxX(_funButton.frame);
		_lifeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_lifeButton.frame = frame;
		[_lifeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
		[_lifeButton setTitle:NSLocalizedString(@"生活服务", nil) forState:UIControlStateNormal];
		_lifeButton.titleLabel.font = font;
		[_lifeButton.titleLabel sizeToFit];
		[_lifeButton setImage:[UIImage imageNamed:@"StoreLife"] forState:UIControlStateNormal];
		[_lifeButton setImage:[UIImage imageNamed:@"StoreLifeSelected"] forState:UIControlStateSelected];
		_lifeButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsets.top, -foodImage.size.width, 0, 0);
		_lifeButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsets.top, 0, 0, -_lifeButton.titleLabel.bounds.size.width);
		
		frame.origin.x = CGRectGetMaxX(_lifeButton.frame);
		_allButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_allButton.frame = frame;
		[_allButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
		[_allButton setTitle:NSLocalizedString(@"全部分类", nil) forState:UIControlStateNormal];
		_allButton.titleLabel.font = font;
		[_allButton.titleLabel sizeToFit];
		[_allButton setImage:[UIImage imageNamed:@"StoreAll"] forState:UIControlStateNormal];
		[_allButton setImage:[UIImage imageNamed:@"StoreAllSelected"] forState:UIControlStateSelected];
		_allButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsets.top, -foodImage.size.width, 0, 0);
		_allButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsets.top, 0, 0, -_allButton.titleLabel.bounds.size.width);
		
		[self.contentView addSubview:_foodButton];
		[self.contentView addSubview:_funButton];
		[self.contentView addSubview:_lifeButton];
		[self.contentView addSubview:_allButton];
	}
	return self;
}

@end
