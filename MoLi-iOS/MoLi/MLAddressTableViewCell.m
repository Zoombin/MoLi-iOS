//
//  MLAddressTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/13/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAddressTableViewCell.h"
#import "Header.h"

@interface MLAddressTableViewCell ()

@property (readwrite) UIImageView *defaultAddressTopLine;
@property (readwrite) UIImageView *defaultAddressBottonLine;
@property (readwrite) UILabel *indexLabel;
@property (readwrite) UIButton *defaultButton;
@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *cityLabel;
@property (readwrite) UILabel *addressLabel;

@end

@implementation MLAddressTableViewCell

+ (CGFloat)height {
	return 130;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		UIImage *image = [UIImage imageNamed:@"DefaultAddressLine"];
		
		_defaultAddressTopLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fullWidth, image.size.height)];
		_defaultAddressTopLine.image = image;
		_defaultAddressTopLine.hidden = YES;
		[self.contentView addSubview:_defaultAddressTopLine];
		
		_defaultAddressBottonLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, [[self class] height] - image.size.height, fullWidth, image.size.height)];
		_defaultAddressBottonLine.image = image;
		_defaultAddressBottonLine.hidden = YES;
		[self.contentView addSubview:_defaultAddressBottonLine];
		
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
		CGRect rect = CGRectZero;
		rect.origin.x = edgeInsets.left;
		rect.origin.y = 12;
		rect.size.width = fullWidth - edgeInsets.left - edgeInsets.right;
		rect.size.height = 30;
		
		_indexLabel = [[UILabel alloc] initWithFrame:rect];
		_indexLabel.textColor = [UIColor blackColor];
		_indexLabel.font = [UIFont systemFontOfSize:15];
		[self.contentView addSubview:_indexLabel];
		
		rect.size.width = 70;
		rect.origin.x = fullWidth - edgeInsets.right - rect.size.width;
		_defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_defaultButton.frame = rect;
		[_defaultButton setTitleColor:[UIColor fontGrayColor] forState:UIControlStateNormal];
		[_defaultButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
		[_defaultButton setTitle:@"[设为默认]" forState:UIControlStateNormal];
		[_defaultButton setTitle:@"[已默认]" forState:UIControlStateSelected];
		_defaultButton.titleLabel.font = [UIFont systemFontOfSize:13];
		[_defaultButton addTarget:self action:@selector(setDefault) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_defaultButton];
		
		rect.origin.x = edgeInsets.left;
		rect.origin.y = CGRectGetMaxY(_indexLabel.frame);
		rect.size.width = fullWidth - edgeInsets.left - edgeInsets.right;
		rect.size.height = 0.5;
		UIView *line = [UIView borderLineWithFrame:rect];
		[self.contentView addSubview:line];

		rect.origin.y = CGRectGetMaxY(line.frame) + 3;
		rect.size.height = 30;
		_nameLabel = [[UILabel alloc] initWithFrame:rect];
		_nameLabel.textColor = [UIColor fontGrayColor];
		_nameLabel.font = [UIFont systemFontOfSize:14];
		[self.contentView addSubview:_nameLabel];
		
		rect.origin.y = CGRectGetMaxY(_nameLabel.frame) - 7;
		rect.size.width = fullWidth - edgeInsets.left - 30;
		rect.size.height = 30;
		_cityLabel = [[UILabel alloc] initWithFrame:rect];
		_cityLabel.textColor = [UIColor fontGrayColor];
		_cityLabel.font = _nameLabel.font;
		_cityLabel.textColor = _nameLabel.textColor;
		[self.contentView addSubview:_cityLabel];
		
		rect.origin.y = CGRectGetMaxY(_cityLabel.frame) - 10;
		_addressLabel = [[UILabel alloc] initWithFrame:rect];
		_addressLabel.numberOfLines = 0;
		_addressLabel.font = _nameLabel.font;
		_addressLabel.textColor = _nameLabel.textColor;
		[self.contentView addSubview:_addressLabel];
	}
	return self;
}

- (void)setAddress:(MLAddress *)address {
	_address = address;
	if (_address) {
		_defaultAddressTopLine.hidden = !_address.isDefault.boolValue;
		_defaultAddressBottonLine.hidden = !_address.isDefault.boolValue;
		_defaultButton.selected = _address.isDefault.boolValue;
		NSString *phone = _address.phone;
		if (!phone.length) {
			phone = _address.mobile;
		}
		_nameLabel.text = [NSString stringWithFormat:@"%@      %@", _address.name, phone.length ? phone : @""];
		_addressLabel.text = _address.street;
		NSMutableString *city = [NSMutableString string];
		if (_address.province.length) {
			[city appendString:_address.province];
		}
		if (_address.city.length) {
			[city appendString:_address.city];
		}
		if (_address.area.length) {
			[city appendString:_address.area];
		}
		_cityLabel.text = city;
	}
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
	_indexPath = indexPath;
	if (_indexPath) {
		_indexLabel.text = [NSString stringWithFormat:@"收货地址%@", @(indexPath.section + 1)];
	}
}

- (void)setEditOrderMode:(BOOL)editOrderMode {
	_editOrderMode = editOrderMode;
	if (_editOrderMode) {
		_indexLabel.text = [NSString stringWithFormat:@"收货地址"];
		_defaultButton.hidden = YES;
		_defaultAddressTopLine.hidden = YES;
		_defaultAddressBottonLine.hidden = YES;
	}
}

- (void)setAfterSaleCellState:(MLAfterSalesType)type {
    _defaultAddressTopLine.hidden = YES;
    _defaultAddressBottonLine.hidden = YES;
    _indexLabel.text = [NSString stringWithFormat:@"选择%@地址",(type==MLAfterSalesTypeReturn)?@"退货":@"换货"];
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_defaultAddressTopLine.hidden = YES;
	_defaultAddressBottonLine.hidden = YES;
	_indexLabel.text = nil;
	_defaultButton.selected = NO;
	_nameLabel.text = nil;
	_addressLabel.text = nil;
}

- (void)setDefault {
	if (_delegate) {
		[_delegate setDefaultAddress:_address];
	}
}

@end
