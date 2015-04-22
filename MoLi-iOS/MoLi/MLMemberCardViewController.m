//
//  MLMemberCardViewController.m
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLMemberCardViewController.h"
#import "Header.h"
#import "MLMemberCard.h"
#import "MLDepositViewController.h"
#import "MLPrivilegeViewController.h"

NSString * const spacesString = @"    ";

@interface MLMemberCardViewController ()

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) MLMemberCard *memberCard;
@property (readwrite) UIImageView *logoView;
@property (readwrite) UIImageView *barView;
@property (readwrite) UIImageView *QRCodeView;
@property (readwrite) UILabel *messageLabel;
@property (readwrite) UILabel *dayLabel;
@property (readwrite) UILabel *hourLabel;
@property (readwrite) UILabel *minuteLabel;
@property (readwrite) UILabel *secondLabel;
@property (readwrite) UIScrollView *notVIPScrollView;
@property (readwrite) UIImageView *fullScreenImageView;

@end

@implementation MLMemberCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = @"电子会员卡";
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:_scrollView];
	
	CGRect rect = CGRectZero;
	UIImage *logo = [UIImage imageNamed:@"Logo"];
	rect.size = logo.size;
	rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
	rect.origin.y = 20;
	_logoView = [[UIImageView alloc] initWithImage:logo];
	_logoView.frame = rect;
	[_scrollView addSubview:_logoView];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(_logoView.frame) + 10;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 20;
	_messageLabel = [[UILabel alloc] initWithFrame:rect];
	_messageLabel.textAlignment = NSTextAlignmentCenter;
	_messageLabel.font = [UIFont systemFontOfSize:12];
	_messageLabel.textColor = [UIColor fontGrayColor];
	[_scrollView addSubview:_messageLabel];

	rect.size.width = 196;
	rect.size.height = 112;
	rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
	rect.origin.y = CGRectGetMaxY(_messageLabel.frame) + 5;
	_barView = [[UIImageView alloc] initWithFrame:rect];
	_barView.contentMode = UIViewContentModeScaleAspectFit;
	_barView.userInteractionEnabled = YES;
	[_scrollView addSubview:_barView];
	
	UITapGestureRecognizer *tapBar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBar)];
	[_barView addGestureRecognizer:tapBar];
	
	rect.origin.y = CGRectGetMaxY(_barView.frame) - 3;
	rect.size.height = 5;
	UIImageView *separatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Separator"]];
	separatorImageView.frame = rect;
	[_scrollView addSubview:separatorImageView];
	
	rect.origin.y = CGRectGetMaxY(separatorImageView.frame);
	rect.size.width = 196;
	rect.size.height = rect.size.width;
	_QRCodeView = [[UIImageView alloc] initWithFrame:rect];
	_QRCodeView.contentMode = UIViewContentModeScaleAspectFit;
	_QRCodeView.userInteractionEnabled = YES;
	[_scrollView addSubview:_QRCodeView];
	
	UITapGestureRecognizer *tapQRCode = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedQRCode)];
	[_QRCodeView addGestureRecognizer:tapQRCode];

	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(_QRCodeView.frame) + 23;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 40;
	UILabel *label = [[UILabel alloc] initWithFrame:rect];
	label.text = @"剩余有效期";
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:20];
	label.textColor = DEF_UIColorFromRGB(0x949494);
    label.shadowOffset = CGSizeMake(1, 2);
    label.shadowColor = [UIColor whiteColor];
	[_scrollView addSubview:label];
	
	CGFloat labelWidth = 66;
	rect.size.width = labelWidth;
	rect.size.height = 40;
	rect.origin.x = (self.view.bounds.size.width - 4 * labelWidth) / 2;
	rect.origin.y = CGRectGetMaxY(label.frame) ;
	_dayLabel = [[UILabel alloc] initWithFrame:rect];
	_dayLabel.textAlignment = NSTextAlignmentCenter;
	_dayLabel.textColor = [UIColor redColor];
	_dayLabel.font = [UIFont systemFontOfSize:20];
    _dayLabel.shadowOffset = CGSizeMake(1, 2);
    _dayLabel.shadowColor = [UIColor whiteColor];
	[_scrollView addSubview:_dayLabel];
	
	rect.origin.x = CGRectGetMaxX(_dayLabel.frame);
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x, CGRectGetMinY(_dayLabel.frame)+13, 1, 16)];
    line1.layer.shadowOffset = CGSizeMake(3, 3);
    line1.layer.shadowColor = [UIColor whiteColor].CGColor;
    line1.layer.shadowOpacity = 1;
    [line1 setBackgroundColor:DEF_UIColorFromRGB(0xdcdcdc)];
    [_scrollView addSubview:line1];
    
    rect.origin.x = rect.origin.x+1;
	_hourLabel = [[UILabel alloc] initWithFrame:rect];
	_hourLabel.textAlignment = _dayLabel.textAlignment;
	_hourLabel.textColor = _dayLabel.textColor;
	_hourLabel.font = _dayLabel.font;
    _hourLabel.shadowOffset = CGSizeMake(1, 2);
    _hourLabel.shadowColor = [UIColor whiteColor];
	[_scrollView addSubview:_hourLabel];
	
	rect.origin.x = CGRectGetMaxX(_hourLabel.frame);
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x, CGRectGetMinY(_dayLabel.frame)+13, 1, 16)];
    line2.layer.shadowColor = [UIColor whiteColor].CGColor;
    line2.layer.shadowOpacity = 1;
    line2.layer.shadowOffset = CGSizeMake(4, 4);
    [line2 setBackgroundColor:DEF_UIColorFromRGB(0xdcdcdc)];
    [_scrollView addSubview:line2];
    
    rect.origin.x = rect.origin.x+1;
	_minuteLabel = [[UILabel alloc] initWithFrame:rect];
	_minuteLabel.textAlignment = _dayLabel.textAlignment;
	_minuteLabel.textColor = _dayLabel.textColor;
	_minuteLabel.font = _dayLabel.font;
    _minuteLabel.shadowOffset = CGSizeMake(1, 2);
    _minuteLabel.shadowColor = [UIColor whiteColor];
	[_scrollView addSubview:_minuteLabel];
	
	rect.origin.x = CGRectGetMaxX(_minuteLabel.frame);
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x, CGRectGetMinY(_dayLabel.frame)+13, 1, 16)];
    line3.layer.shadowColor = [UIColor whiteColor].CGColor;
    line3.layer.shadowOpacity = 1;
    line3.layer.shadowOffset = CGSizeMake(2, 1);
    [line3 setBackgroundColor:DEF_UIColorFromRGB(0xdcdcdc)];
    [_scrollView addSubview:line3];
    
    rect.origin.x = rect.origin.x+1;
	_secondLabel = [[UILabel alloc] initWithFrame:rect];
	_secondLabel.textAlignment = _dayLabel.textAlignment;
	_secondLabel.textColor = _dayLabel.textColor;
	_secondLabel.font = _dayLabel.font;
    _secondLabel.shadowOffset = CGSizeMake(1, 2);
    _secondLabel.shadowColor = [UIColor whiteColor];
	[_scrollView addSubview:_secondLabel];
	
	_scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, CGRectGetMaxY(_secondLabel.frame));
	
	_notVIPScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_notVIPScrollView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:_notVIPScrollView];
	
	UIImage *image = [UIImage imageNamed:@"MoliGirl"];
	rect.size = image.size;
	rect.origin.x = (self.view.bounds.size.width - image.size.width) / 2;
	rect.origin.y = 110;
	UIImageView *moliGirlImageView = [[UIImageView alloc] initWithFrame:rect];
	moliGirlImageView.image = image;
	[_notVIPScrollView addSubview:moliGirlImageView];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(moliGirlImageView.frame) + 20;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 40;
	UILabel *notVIPLabel = [[UILabel alloc] initWithFrame:rect];
	notVIPLabel.textColor = [UIColor themeColor];
	notVIPLabel.textAlignment = NSTextAlignmentCenter;
	notVIPLabel.font = [UIFont systemFontOfSize:23];
	notVIPLabel.text = @"您还不是魔力网的会员哦!";
	[_notVIPScrollView addSubview:notVIPLabel];
	
	rect.origin.x = 0;
	rect.origin.y = CGRectGetMaxY(notVIPLabel.frame);
	rect.size.width = self.view.bounds.size.width / 2;
	rect.size.height = 20;
	UILabel *privilegeLable = [[UILabel alloc] initWithFrame:rect];
	NSString *flagString = @"了解会员特权";
	NSString *text = [NSString stringWithFormat:@"点此 %@", flagString];
	NSRange range = [text rangeOfString:flagString];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
	privilegeLable.textAlignment = NSTextAlignmentRight;
	privilegeLable.textColor = [UIColor fontGrayColor];
	privilegeLable.font = [UIFont systemFontOfSize:12];
	[attributedString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} range:range];
	privilegeLable.attributedText = attributedString;
	[_notVIPScrollView addSubview:privilegeLable];
	
	rect.origin.x = CGRectGetMaxX(privilegeLable.frame);
	UILabel *joinLabel = [[UILabel alloc] initWithFrame:rect];
	NSString *flagString2 = @"加入会员";
	NSString *text2 = [NSString stringWithFormat:@" 或者点此 %@", flagString2];
	NSRange range2 = [text2 rangeOfString:flagString2];
	NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:text2];
	joinLabel.textColor = [UIColor fontGrayColor];
	joinLabel.font = [UIFont systemFontOfSize:12];
	[attributedString2 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} range:range2];
	joinLabel.attributedText = attributedString2;
	[_notVIPScrollView addSubview:joinLabel];
	
	rect.size.width = 76;
	rect.size.height = 1;
	rect.origin.x = (self.view.bounds.size.width / 2) - rect.size.width;
	rect.origin.y = CGRectGetMaxY(privilegeLable.frame) - 2;
	UIView *underline1 = [[UIView alloc] initWithFrame:rect];
	underline1.backgroundColor = [UIColor fontGrayColor];
	[_notVIPScrollView addSubview:underline1];
	
	rect.size.width = 52;
	rect.origin.x = (self.view.bounds.size.width / 2) + 56;
	UIView *underline2 = [[UIView alloc] initWithFrame:rect];
	underline2.backgroundColor = underline1.backgroundColor;
	[_notVIPScrollView addSubview:underline2];
	
	UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(privilege)];
	privilegeLable.userInteractionEnabled = YES;
	[privilegeLable addGestureRecognizer:tap1];
	
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(join)];
	joinLabel.userInteractionEnabled = YES;
	[joinLabel addGestureRecognizer:tap2];
	
	_scrollView.hidden = YES;
	_notVIPScrollView.hidden = YES;
	
	_fullScreenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 20, self.view.bounds.size.height)];
	_fullScreenImageView.hidden = YES;
	_fullScreenImageView.backgroundColor = self.view.backgroundColor;
	_fullScreenImageView.contentMode = UIViewContentModeScaleAspectFit;
	_fullScreenImageView.userInteractionEnabled = YES;
	[self.view addSubview:_fullScreenImageView];
	UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFullScreenImageView)];
	[_fullScreenImageView addGestureRecognizer:hideTap];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self refresh:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tappedBar {
	_fullScreenImageView.image = _barView.image;
	_fullScreenImageView.hidden = NO;
}

- (void)tappedQRCode {
	_fullScreenImageView.image = _QRCodeView.image;
	_fullScreenImageView.hidden = NO;
}

- (void)hideFullScreenImageView {
	_fullScreenImageView.hidden = YES;
}

- (void)privilege {
	MLPrivilegeViewController *privilegeViewController = [[MLPrivilegeViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:privilegeViewController animated:YES];
}

- (void)join {
	MLDepositViewController *depositViewController = [[MLDepositViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:depositViewController animated:YES];
}

- (NSUInteger)secondsPerMinutes {
	return 60;
}

- (NSUInteger)minutesPerHour {
	return 60;
}

- (NSUInteger)hoursPerDay {
	return 24;
}

- (NSUInteger)secondsPerHour {
	return [self secondsPerMinutes] * [self minutesPerHour];
}

- (NSUInteger)secondsPerDay {
	return [self secondsPerMinutes] * [self minutesPerHour] * [self hoursPerDay];
}

- (void)countdown {
	_memberCard.expireSeconds = @(_memberCard.expireSeconds.unsignedIntegerValue - 1);
	[self refreshCountdownLabel];
	[self performSelector:@selector(countdown) withObject:nil afterDelay:1];
}

- (void)refreshCountdownLabel {
	NSUInteger days = _memberCard.expireSeconds.unsignedIntegerValue / [self secondsPerDay];
	NSUInteger daysSeconds = days * [self secondsPerDay];
	NSUInteger hours = (_memberCard.expireSeconds.unsignedIntegerValue - daysSeconds) / [self secondsPerHour];
	NSUInteger hoursSeconds = hours * [self secondsPerHour];
	NSUInteger minutes = (_memberCard.expireSeconds.unsignedIntegerValue - daysSeconds - hoursSeconds) / [self secondsPerMinutes];
	NSUInteger minutesSeconds = minutes * [self secondsPerMinutes];
	NSUInteger seconds = _memberCard.expireSeconds.unsignedIntegerValue - daysSeconds - hoursSeconds - minutesSeconds;
	
	NSString *string = nil;
	NSMutableAttributedString *attributedString = nil;
	NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:13]};
	
	string = [NSString stringWithFormat:@"%@ 天", @(days)];
	attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	[attributedString addAttributes:attributes range:NSMakeRange(string.length - 1, 1)];
	_dayLabel.attributedText = attributedString;
	
	
	string = [NSString stringWithFormat:@"%@ 时", @(hours)];
	attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	[attributedString addAttributes:attributes range:NSMakeRange(string.length - 1, 1)];
	_hourLabel.attributedText = attributedString;
	
	string = [NSString stringWithFormat:@"%@ 分", @(minutes)];
	attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	[attributedString addAttributes:attributes range:NSMakeRange(string.length - 1, 1)];
	_minuteLabel.attributedText = attributedString;
	
	string = [NSString stringWithFormat:@"%@ 秒", @(seconds)];
	attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	[attributedString addAttributes:attributes range:NSMakeRange(string.length - 1, 1)];
	_secondLabel.attributedText = attributedString;
}

- (void)refresh {
	[self refresh:NO];
}

- (void)refresh:(BOOL)executeCountdown {
	[self displayHUD:NSLocalizedString(@"加载中...", nil)];
	[[MLAPIClient shared] memeberCardWithBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			_memberCard = [[MLMemberCard alloc] initWithAttributes:attributes];
			NSLog(@"memberCard: %@", _memberCard);
			
			_scrollView.hidden = ![_memberCard isVIP].boolValue;
			_notVIPScrollView.hidden = [_memberCard isVIP].boolValue;
			
			if ([_memberCard isVIP].boolValue) {
				self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"刷新", nil) style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
				
                BOOL isFullImageEqualBarImage = _fullScreenImageView.image==_barView.image?YES:NO;
                
				if (_memberCard.barImagePath) {
					[[MLAPIClient shared] fetchImageWithPath:_memberCard.barImagePath withBlock:^(UIImage *image) {
						_barView.image = image;
                        if(isFullImageEqualBarImage)
                            _fullScreenImageView.image = _barView.image;
					}];
				}
				if (_memberCard.QRCodeImagePath) {
					[[MLAPIClient shared] fetchImageWithPath:_memberCard.QRCodeImagePath withBlock:^(UIImage *image) {
						_QRCodeView.image = image;
                        if (!isFullImageEqualBarImage) {
                            _fullScreenImageView.image = _QRCodeView.image;
                        }
					}];
				}
                
				_messageLabel.text = @"给收银员扫一扫完成魔力会员身份验证";//_memberCard.message;
				if (executeCountdown) {
					[self countdown];
				}
			} else {
			}
		}
	}];
}

@end
