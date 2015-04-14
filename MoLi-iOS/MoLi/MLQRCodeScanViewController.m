//
//  MLQRCodeScanViewController.m
//  MoLi
//
//  Created by zhangbin on 1/23/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLQRCodeScanViewController.h"
#import "Header.h"
#import "ZBarSDK.h"

static CGFloat const startYForScanLine = 223.5;

@interface MLQRCodeScanViewController () <ZBarReaderViewDelegate>

@property (readwrite) UIImageView *scanFrameImageView;
@property (readwrite) UIView *scanline;
@property (readwrite) CGFloat endYForScanLine;
@property (readwrite) BOOL bottomToTop;

@end

@implementation MLQRCodeScanViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"扫描二维码";
	[self setLeftBarButtonItemAsBackArrowButton];
	
	ZBarReaderView *readerView = [[ZBarReaderView alloc]init];
	readerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	readerView.readerDelegate = self;
	readerView.torchMode = 0;
	if (TARGET_IPHONE_SIMULATOR) {
		ZBarCameraSimulator *cameraSimulator = [[ZBarCameraSimulator alloc]initWithViewController:self];
		cameraSimulator.readerView = readerView;
	}
	[self.view addSubview:readerView];
	[readerView start];
	
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 16, 10, 16);
	CGRect rect = CGRectZero;
	rect.origin.y = 50;
	UIImage *backgroundImage = [UIImage imageNamed:@"QRCodeBackground"];
	rect.size = backgroundImage.size;
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:rect];
	backgroundImageView.image = backgroundImage;
	[self.view addSubview:backgroundImageView];
	
	UIImage *image = [UIImage imageNamed:@"ScanFrame"];
	_endYForScanLine = startYForScanLine - edgeInsets.top - edgeInsets.bottom + image.size.height;
	CGFloat width = image.size.width;
	rect = CGRectMake((self.view.bounds.size.width - width) / 2, startYForScanLine - edgeInsets.top, width, image.size.height);
	_scanFrameImageView = [[UIImageView alloc] initWithFrame:rect];
	_scanFrameImageView.image = image;
	[self.view addSubview:_scanFrameImageView];
	
	rect.origin.x = CGRectGetMinX(_scanFrameImageView.frame) + edgeInsets.left;
	rect.origin.y = startYForScanLine;
	rect.size.width = CGRectGetWidth(_scanFrameImageView.frame) - edgeInsets.left - edgeInsets.right;
	rect.size.height = 2;
	_scanline = [[UIView alloc] initWithFrame:rect];
	_scanline.backgroundColor  = [UIColor themeColor];
	[self.view addSubview:_scanline];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(_scanFrameImageView.frame) + 10;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 30;
	UILabel *label = [[UILabel alloc] initWithFrame:rect];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont systemFontOfSize:16];
	label.textAlignment = NSTextAlignmentCenter;
	label.text = @"将条形码/二维码放入框内，即可自动扫描";
	[self.view addSubview:label];
	
	[self animationScanLine];
}

- (void)animationScanLine {
	CGRect r = _scanline.frame;
	if (_bottomToTop) {
		r.origin.y = startYForScanLine;
	} else {
		r.origin.y = _endYForScanLine;
	}
	[UIView animateWithDuration:2 animations:^{
		_scanline.frame = r;
	} completion:^(BOOL finished) {
		_bottomToTop = !_bottomToTop;
		[self animationScanLine];
	}];
}

#pragma mark - ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
	for (ZBarSymbol *symbol in symbols) {
		NSString *path = symbol.data;
		NSLog(@"path: %@", path);
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:path delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
		[alertView show];
	}
}

@end
