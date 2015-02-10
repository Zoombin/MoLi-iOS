//
//  MLWebViewController.m
//  MoLi
//
//  Created by zhangbin on 11/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLWebViewController.h"
#import "Header.h"

@interface MLWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic, strong) UIToolbar *toolbar;
//@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
//@property (nonatomic, strong) UIBarButtonItem *forwardButtonItem;

@end

@implementation MLWebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_webView = [[UIWebView alloc] initWithFrame:self.view.frame];
	_webView.delegate = self;
//	_webView.backgroundColor = self.view.backgroundColor;
	[self.view addSubview:_webView];
	
//	_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - toolbarHeight, self.view.bounds.size.width, toolbarHeight)];
//	_toolbar.backgroundColor = [UIColor themeColor];
//	[self.view addSubview:_toolbar];
//	
//	_backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
//	_forwardButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ForwardArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goForward:)];
//	_toolbar.items = @[_backButtonItem, _forwardButtonItem];
//	
//	[self updateBackButtonItem];
//	[self updateForwardButtonItem];
	
	[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URLString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
