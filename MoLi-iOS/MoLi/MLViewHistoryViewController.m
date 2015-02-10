//
//  MLViewHistoryViewController.m
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLViewHistoryViewController.h"
#import "Header.h"
#import "MLNoDataView.h"

@interface MLViewHistoryViewController ()

@property (readwrite) MLNoDataView *noDataView;

@end

@implementation MLViewHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"我的足迹", nil);
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"清空", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
	
	_noDataView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_noDataView.imageView.image = [UIImage imageNamed:@"NoViewHistory"];
	_noDataView.label.text = @"您还没有留下足迹";
	//_noDataView.hidden = YES;
	[self.view addSubview:_noDataView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)clear {
	
}

@end
