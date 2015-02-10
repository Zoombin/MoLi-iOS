//
//  MLStoreMemberPrivilegeTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/19/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLStoreMemberPrivilegeTableViewCell.h"
#import "Header.h"

@implementation MLStoreMemberPrivilegeTableViewCell

+ (UITableViewCellStyle)style {
	return UITableViewCellStyleSubtitle;
}

+ (CGFloat)height {
	return 100;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.textLabel.text = NSLocalizedString(@"会员尊享", nil);
		self.textLabel.font = [UIFont systemFontOfSize:20];
		self.textLabel.textColor = [UIColor fontGrayColor];
		
		self.detailTextLabel.numberOfLines = 0;
		self.detailTextLabel.text = @"会员折扣信息：全场9折\n是否需要预约：无需预约\n使用规则：魔力电子会员卡尊享折扣优惠";
		self.detailTextLabel.textColor = [UIColor fontGrayColor];
		self.detailTextLabel.font = [UIFont systemFontOfSize:13];
	}
	return self;
}

@end
