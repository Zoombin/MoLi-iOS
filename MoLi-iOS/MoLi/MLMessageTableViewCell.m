//
//  MLMessageTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 2/9/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLMessageTableViewCell.h"
#import "Header.h"

@interface MLMessageTableViewCell ()

@property (readwrite) UILabel *titleLabel;
@property (readwrite) UILabel *dateLabel;

@end

@implementation MLMessageTableViewCell

+ (CGFloat)height {
	return 72;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		CGRect rect = CGRectZero;
		rect.origin.x = ML_COMMON_EDGE_LEFT;
		rect.origin.y = 10;
		rect.size.width = fullWidth - 2 * ML_COMMON_EDGE_LEFT;
		rect.size.height = 30;
		_titleLabel = [[UILabel alloc] initWithFrame:rect];
		_titleLabel.font = [UIFont systemFontOfSize:15];
		[self.contentView addSubview:_titleLabel];
		
		rect.origin.y = CGRectGetMaxY(_titleLabel.frame);
		rect.size.width = 14;
		rect.size.height = rect.size.width;
		UIImageView *iconView = [[UIImageView alloc] initWithFrame:rect];
		iconView.contentMode = UIViewContentModeScaleAspectFit;
		iconView.image = [UIImage imageNamed:@"Date"];
		[self.contentView addSubview:iconView];
		
		rect.origin.x = CGRectGetMaxX(iconView.frame) + 5;
		rect.size.width = fullWidth - rect.origin.x;
		_dateLabel = [[UILabel alloc] initWithFrame:rect];
		_dateLabel.font = [UIFont systemFontOfSize:13];
		[self.contentView addSubview:_dateLabel];
	}
	return self;
}

- (void)setMessage:(MLMessage *)message {
	_message = message;
	if (_message) {
		_titleLabel.text = _message.title;
		_titleLabel.textColor = message.isRead.boolValue ? [UIColor fontGrayColor] : [UIColor blackColor];
		_dateLabel.text = [_message displaySendDate];
		_dateLabel.textColor = _titleLabel.textColor;
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_titleLabel.text = nil;
	_dateLabel.text = nil;
}

@end
