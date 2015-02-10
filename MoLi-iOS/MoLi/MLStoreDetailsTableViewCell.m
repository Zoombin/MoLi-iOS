//
//  MLStoreDetailsTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/19/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLStoreDetailsTableViewCell.h"
#import "ZBFiveStarsRateView.h"
#import "Header.h"
#import "NSString+ZBUtilites.h"

@interface MLStoreDetailsTableViewCell ()

@property (readwrite) UIImageView *iconView;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) ZBFiveStarsRateView *fiveStarsRateView;
@property (readwrite) UILabel *businessCategoryLabel;
@property (readwrite) UILabel *addressLabel;
@property (readwrite) UIButton *callButton;
@property (readwrite) UIImageView *businessCategoryIconView;

@end

@implementation MLStoreDetailsTableViewCell

+ (CGFloat)height {
	return 150;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 14, 10, 14);
		
		CGRect rect = CGRectZero;
		rect.origin.x = edgeInsets.left;
		rect.origin.y = edgeInsets.top;
		rect.size.width = 80;
		rect.size.height = rect.size.width;
		_iconView = [[UIImageView alloc] initWithFrame:rect];
		[self.contentView addSubview:_iconView];
		
		rect.origin.x = CGRectGetMaxX(_iconView.frame) + 10;
		rect.size.width = fullWidth - rect.origin.x;
		rect.size.height = 30;
		_nameLabel = [[UILabel alloc] initWithFrame:rect];
		[self.contentView addSubview:_nameLabel];
		
		rect.origin.y = CGRectGetMaxY(_nameLabel.frame);
		rect.size = [ZBFiveStarsRateView size];
		_fiveStarsRateView = [[ZBFiveStarsRateView alloc] initWithFrame:rect];
		_fiveStarsRateView.star = [UIImage rateStar];
		_fiveStarsRateView.starHighlighted = [UIImage rateStarHighlighted];
		[self.contentView addSubview:_fiveStarsRateView];
		
		rect.origin.y = CGRectGetMaxY(_fiveStarsRateView.frame) + 10;
		rect.size.width = 16;
		rect.size.height = rect.size.width;
		_businessCategoryIconView = [[UIImageView alloc] initWithFrame:rect];
		_businessCategoryIconView.contentMode = UIViewContentModeCenter;
		[self.contentView addSubview:_businessCategoryIconView];
		
		rect.origin.x = CGRectGetMaxX(_businessCategoryIconView.frame) + 5;
		rect.size.width = fullWidth - rect.origin.x;
		rect.size.height = 12;
		_businessCategoryLabel = [[UILabel alloc] initWithFrame:rect];
		_businessCategoryLabel.textColor = [UIColor fontGrayColor];
		_businessCategoryLabel.font = [UIFont systemFontOfSize:12];
		[self.contentView addSubview:_businessCategoryLabel];
		
		rect.origin.x = edgeInsets.left;
		rect.origin.y = CGRectGetMaxY(_iconView.frame) + 10;
		rect.size.width = fullWidth - edgeInsets.left - edgeInsets.right;
		rect.size.height = 0.5;
		UIView *line = [[UIView alloc] initWithFrame:rect];
		line.backgroundColor = [UIColor lightGrayColor];
		[self.contentView addSubview:line];
		
		rect.origin.x = 24;
		rect.origin.y = CGRectGetMaxY(line.frame) + 18;
		rect.size = _businessCategoryIconView.frame.size;
		UIImageView *addressIconView = [[UIImageView alloc] initWithFrame:rect];
		addressIconView.contentMode = UIViewContentModeCenter;
		addressIconView.image = [UIImage imageNamed:@"Location"];
		[self.contentView addSubview:addressIconView];
		
		CGFloat widthOfCallButton = 60;
		rect.origin.x = CGRectGetMaxX(addressIconView.frame) + 5;
		rect.origin.y = CGRectGetMaxY(line.frame);
		rect.size.width = fullWidth - rect.origin.x - widthOfCallButton;
		rect.size.height = 50;
		_addressLabel = [[UILabel alloc] initWithFrame:rect];
		_addressLabel.numberOfLines = 0;
		_addressLabel.font = [UIFont systemFontOfSize:15];
		_addressLabel.textColor = [UIColor fontGrayColor];
        _addressLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(map)];
        [_addressLabel addGestureRecognizer:gesture];
		[self.contentView addSubview:_addressLabel];
		
		rect.origin.x = CGRectGetMaxX(_addressLabel.frame);
		rect.origin.y = CGRectGetMaxY(line.frame);
		rect.size.width = widthOfCallButton;
		rect.size.height = CGRectGetHeight(_addressLabel.frame);
		_callButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_callButton.frame = rect;
		[_callButton setImage:[UIImage imageNamed:@"Phone"] forState:UIControlStateNormal];
		[_callButton setImage:[UIImage imageNamed:@"PhoneSelected"] forState:UIControlStateSelected];
		[_callButton addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_callButton];
	}
	return self;
}

- (void)map {
    if (_delegate) {
        [_delegate storeDetailsTableViewCellWillMap:_store];
    }
}

- (void)call {
	if (_delegate) {
		[_delegate storeDetailsTableViewCellWillCall:_store];
	}
}

- (void)setStore:(MLStore *)store {
	_store = store;
	if (_store) {
		[_iconView setImageWithURL:[NSURL URLWithString:_store.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		_nameLabel.text = _store.name;
		_fiveStarsRateView.rate = _store.starRated;
		_businessCategoryLabel.text = _store.businessCategory;
		_addressLabel.text = _store.address;
        _businessCategoryIconView.image = [MLStore imageByStoreCategory:_store.businessCategory];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_iconView.image = nil;
	_nameLabel.text = nil;
	[_fiveStarsRateView reset];
	_businessCategoryLabel.text = nil;
	_addressLabel.text = nil;
}

@end
