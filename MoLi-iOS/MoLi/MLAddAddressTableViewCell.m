//
//  MLAddAddressTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/15/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAddAddressTableViewCell.h"
#import "Header.h"

@implementation MLAddAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.textLabel.text = @"添加地址";
		self.textLabel.textAlignment = NSTextAlignmentCenter;
		self.textLabel.textColor = [UIColor themeColor];
		self.textLabel.font = [UIFont systemFontOfSize:13];
		
#warning TODO add a icon
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
		imageView.image = [UIImage imageNamed:@""];
	}
	return self;
}

@end
