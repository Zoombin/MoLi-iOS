//
//  MLPrivilegeViewController.m
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLPrivilegeViewController.h"
#import "Header.h"

@interface MLPrivilegeViewController ()

@end

@implementation MLPrivilegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"会员特权";
	[self setLeftBarButtonItemAsBackArrowButton];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	scrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:scrollView];
	
	UIImage *image1 = [UIImage imageNamed:@"Privilege1"];
	UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image1];
	imageView1.frame = CGRectMake(0, 0, self.view.frame.size.width, image1.size.height);
	[scrollView addSubview:imageView1];
	
	UIImage *image2 = [UIImage imageNamed:@"Privilege2"];
	UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
	imageView2.frame = CGRectMake(0, CGRectGetMaxY(imageView1.frame), self.view.frame.size.width, image2.size.height);
	[scrollView addSubview:imageView2];

	UIImage *image3 = [UIImage imageNamed:@"Privilege3"];
	UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image3];
	imageView3.frame = CGRectMake(0, CGRectGetMaxY(imageView2.frame), self.view.frame.size.width, image3.size.height);
	[scrollView addSubview:imageView3];

	scrollView.contentSize = CGSizeMake(self.view.frame.size.width, image1.size.height + image2.size.height + image3.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
