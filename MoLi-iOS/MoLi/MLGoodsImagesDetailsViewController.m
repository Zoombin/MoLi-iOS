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

@interface MLGoodsImagesDetailsViewController () <UMSocialUIDelegate>

@property (readwrite) UIWebView *webView;
@property (readwrite) MLGoodsImagesDetails *imagesDetails;
@property (readwrite) BOOL sharing;

@end

@implementation MLGoodsImagesDetailsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
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
	if (_sharing) return;
	_sharing = YES;
    [[MLAPIClient shared] shareWithObject:MLShareObjectGoods platform:MLSharePlatformQQ objectID:_goods.ID withBlock:^(NSDictionary *attributes, MLResponse *response) {
        [self displayResponseMessage:response];
        if (response.success) {
            MLShare *share = [[MLShare alloc] initWithAttributes:attributes];
            [UMSocialSnsService presentSnsIconSheetView:self appKey:ML_UMENG_APP_KEY shareText:share.word shareImage:[UIImage imageNamed:@"MoliIcon"] shareToSnsNames:@[UMShareToSina, UMShareToQzone, UMShareToQQ, UMShareToWechatTimeline, UMShareToWechatSession] delegate:self];
        }
    }];
}

#pragma mark - UMSocialUIDelegate

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
	_sharing = NO;
}

@end
