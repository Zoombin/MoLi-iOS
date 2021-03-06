//
//  MLGoodsImagesDetailsViewController.m
//  MoLi
//
//  Created by zhangbin on 12/22/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoodsImagesDetailsViewController.h"
#import "Header.h"
#import "MLGoodsImagesDetails.h"
#import "MLWebViewController.h"

@interface MLGoodsImagesDetailsViewController ()

@property (readwrite) UIWebView *webView;
@property (readwrite) MLGoodsImagesDetails *imagesDetails;

@end

@implementation MLGoodsImagesDetailsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	self.title = @"图文详情";

	self.view.backgroundColor = [UIColor backgroundColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_webView = [[UIWebView alloc] initWithFrame:self.view.frame];
	_webView.scalesPageToFit = YES;
	[self.view addSubview:_webView];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
	[self.view addGestureRecognizer:tap];
	
	[self displayHUD:NSLocalizedString(@"加载中...", nil)];
	[[MLAPIClient shared] goodsImagesDetails:_goods.ID withBlock:^(NSDictionary *attributes, NSError *error) {
		[self hideHUD:YES];
		if (!error) {
			_imagesDetails = [[MLGoodsImagesDetails alloc] initWithAttributes:attributes];
//			NSArray *tmp = @[@"http://www.w3school.com.cn/i/eg_tulip.jpg",
//							 @"http://www.w3school.com.cn/i/eg_tulip.jpg",
//							 @"http://www.w3school.com.cn/i/eg_tulip.jpg",
//							 @"http://www.w3school.com.cn/i/eg_tulip.jpg"
//							 ];
//			_imagesDetails.imagePaths = tmp;
//			NSMutableString *html = [@"<html><body>" mutableCopy];
//			for (int i = 0; i < _imagesDetails.imagePaths.count; i++) {
//				[html appendFormat:@"<a href=\"%@\"><img src=\"%@\" /></a>", _imagesDetails.link, _imagesDetails.imagePaths[i]];
//			}
//			[html appendString:@"</body></html>"];
			//if (_goods)
			//[_webView loadHTMLString:html baseURL:nil];
			if (_imagesDetails.link) {
				NSURL *URL = [NSURL URLWithString:_imagesDetails.link];
				[_webView loadRequest:[NSURLRequest requestWithURL:URL]];
			}
		}
	}];
    
	UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    [self.navigationItem setRightBarButtonItem:shareBarButtonItem];
}

- (void)tapped {
	if (_imagesDetails.link.length) {
		MLWebViewController *webViewController = [[MLWebViewController alloc] initWithNibName:nil bundle:nil];
		webViewController.URLString = _imagesDetails.link;
		[self.navigationController pushViewController:webViewController animated:YES];
	}
}

- (void)share {
	[self socialShare:MLShareObjectGoods objectID:_goods.ID];
}

@end
