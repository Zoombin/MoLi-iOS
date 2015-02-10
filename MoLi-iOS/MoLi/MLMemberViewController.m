//
//  MLMemberViewController.m
//  MoLi
//
//  Created by zhangbin on 12/10/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLMemberViewController.h"
#import "Header.h"
#import "MLDepositViewController.h"
#import "MLPrivilegeViewController.h"
#import "MLMemberCardViewController.h"


@interface MLMemberViewController ()

@end

@implementation MLMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"会员中心";
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:scrollView];
	
	CGRect rect = CGRectZero;
	
	UIImage *image = [UIImage imageNamed:@"MemberCenter"];
	rect.size.width = self.view.frame.size.width;
	rect.size.height = image.size.height;
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = rect;
	[scrollView addSubview:imageView];
	
	rect.origin.y = CGRectGetMaxY(imageView.frame) + 20;
	rect.size.width = 94;
	rect.size.height = 118;
	CGFloat gap = [NSNumber edgeWithMaxWidth:self.view.bounds.size.width itemWidth:rect.size.width numberPerLine:3].floatValue;
	rect.origin.x = gap;
	
	UIFont *font = [UIFont systemFontOfSize:15];
	UIColor *borderColor = [UIColor borderGrayColor];
	CGFloat borderWidth = 0.5;
	UIColor *titleColor = [UIColor fontGrayColor];
	CGFloat imageEdgeTop = -30;
	CGFloat titleEdgeTop = 60;
	
	UIImage *buttonImage = [UIImage imageNamed:@"MemberCard"];
	UIButton *memberCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
	memberCardButton.frame = rect;
	memberCardButton.backgroundColor = [UIColor whiteColor];
	[memberCardButton setTitle:@"电子会员卡" forState:UIControlStateNormal];
	[memberCardButton setImage:buttonImage forState:UIControlStateNormal];
	memberCardButton.layer.borderColor = [borderColor CGColor];
	memberCardButton.layer.borderWidth = borderWidth;
	memberCardButton.titleLabel.textColor = titleColor;
	memberCardButton.titleLabel.font = font;
	[memberCardButton.titleLabel sizeToFit];
	[memberCardButton setTitleColor:titleColor forState:UIControlStateNormal];
	[memberCardButton setTitleEdgeInsets:UIEdgeInsetsMake(titleEdgeTop, -buttonImage.size.width, 0, 0)];
	[memberCardButton setImageEdgeInsets:UIEdgeInsetsMake(imageEdgeTop, 0, 0, -memberCardButton.titleLabel.bounds.size.width)];
	[memberCardButton addTarget:self action:@selector(memberCard) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:memberCardButton];
	
	rect.origin.x = CGRectGetMaxX(memberCardButton.frame) + gap;
	UIButton *depositButton = [UIButton buttonWithType:UIButtonTypeCustom];
	depositButton.frame = rect;
	depositButton.backgroundColor = [UIColor whiteColor];
	[depositButton setTitle:@"充值、续费" forState:UIControlStateNormal];
	[depositButton setImage:[UIImage imageNamed:@"Deposit"] forState:UIControlStateNormal];
	depositButton.layer.borderColor = [borderColor CGColor];
	depositButton.titleLabel.font = font;
	depositButton.layer.borderWidth = borderWidth;
	[depositButton setTitleColor:titleColor forState:UIControlStateNormal];
	[depositButton.titleLabel sizeToFit];
	[depositButton setTitleEdgeInsets:UIEdgeInsetsMake(titleEdgeTop, -buttonImage.size.width, 0, 0)];
	[depositButton setImageEdgeInsets:UIEdgeInsetsMake(imageEdgeTop, 0, 0, -depositButton.titleLabel.bounds.size.width)];
	[depositButton addTarget:self action:@selector(deposit) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:depositButton];
	
	rect.origin.x = CGRectGetMaxX(depositButton.frame) + gap;
	UIButton *privilegeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	privilegeButton.frame = rect;
	privilegeButton.backgroundColor = [UIColor whiteColor];
	[privilegeButton setTitle:@"会员特权" forState:UIControlStateNormal];
	[privilegeButton setImage:[UIImage imageNamed:@"Privilege"] forState:UIControlStateNormal];
	privilegeButton.layer.borderColor = [borderColor CGColor];
	privilegeButton.layer.borderWidth = borderWidth;
	privilegeButton.titleLabel.font = font;
	privilegeButton.titleLabel.textColor = titleColor;
	[privilegeButton setTitleColor:titleColor forState:UIControlStateNormal];
	[privilegeButton.titleLabel sizeToFit];
	[privilegeButton setTitleEdgeInsets:UIEdgeInsetsMake(titleEdgeTop, -buttonImage.size.width, 0, 0)];
	[privilegeButton setImageEdgeInsets:UIEdgeInsetsMake(imageEdgeTop, 0, 0, -privilegeButton.titleLabel.bounds.size.width)];
	[privilegeButton addTarget:self action:@selector(privilege) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:privilegeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)memberCard {
	MLMemberCardViewController *memberCardViewController = [[MLMemberCardViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:memberCardViewController animated:YES];
}

- (void)deposit {
	MLDepositViewController *depositViewController = [[MLDepositViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:depositViewController animated:YES];
}

- (void)privilege {
	MLPrivilegeViewController *privilegeViewController = [[MLPrivilegeViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:privilegeViewController animated:YES];
}


@end
