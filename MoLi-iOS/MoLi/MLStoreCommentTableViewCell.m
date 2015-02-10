//
//  MLStoreCommentTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/19/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLStoreCommentTableViewCell.h"
#import "Header.h"
#import "ZBFiveStarsRateView.h"

@interface MLStoreCommentTableViewCell ()

@property (readwrite) UILabel *usernameLabel;
@property (readwrite) UILabel *dateLabel;
@property (readwrite) ZBFiveStarsRateView *fiveStarsRateView;
@property (readwrite) UILabel *contentLabel;

@end

@implementation MLStoreCommentTableViewCell

+ (CGFloat)height {
	return 80;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		CGRect frame = CGRectZero;
		frame.origin.x = 20;
		frame.origin.y = 10;
		frame.size.width = fullWidth - 2 * frame.origin.x;
		frame.size.height = 15;
		_usernameLabel = [[UILabel alloc] initWithFrame:frame];
		_usernameLabel.font = [UIFont systemFontOfSize:13];
		_usernameLabel.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:_usernameLabel];
		
		frame.origin.y = CGRectGetMaxY(_usernameLabel.frame);
		_dateLabel = [[UILabel alloc] initWithFrame:frame];
		_dateLabel.font = [UIFont systemFontOfSize:13];
		_dateLabel.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:_dateLabel];
	
		frame.size = [ZBFiveStarsRateView size];
		frame.origin.x = fullWidth - frame.size.width - 20;
		frame.origin.y = 10;
		_fiveStarsRateView = [[ZBFiveStarsRateView alloc] initWithFrame:frame];
		_fiveStarsRateView.star = [UIImage rateStar];
		_fiveStarsRateView.starHighlighted = [UIImage rateStarHighlighted];
		[self.contentView addSubview:_fiveStarsRateView];

		frame.origin.x = CGRectGetMinX(_usernameLabel.frame);
		frame.origin.y = CGRectGetMaxY(_dateLabel.frame);
		frame.size.width = CGRectGetWidth(_usernameLabel.frame);
		frame.size.height = 40;
		_contentLabel = [[UILabel alloc] initWithFrame:frame];
		_contentLabel.textColor = [UIColor fontGrayColor];
		_contentLabel.font = [UIFont systemFontOfSize:15];
		_contentLabel.numberOfLines = 0;
		[self.contentView addSubview:_contentLabel];
	}
	return self;
}

- (void)setStoreComment:(MLStoreComment *)storeComment {
	_storeComment = storeComment;
	if (_storeComment) {
		_usernameLabel.text = _storeComment.username;
		_dateLabel.text = _storeComment.dateString;
		_fiveStarsRateView.rate = _storeComment.star;
		_contentLabel.text = _storeComment.content;
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_usernameLabel.text = nil;
	_dateLabel.text = nil;
	[_fiveStarsRateView reset];
	_contentLabel.text = nil;
}

@end
