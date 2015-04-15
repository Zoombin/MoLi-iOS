//
//  MLVoucherTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLVoucherTableViewCell.h"
#import "Header.h"

@interface MLVoucherTableViewCell ()

@property (readwrite) UILabel *label;
@property (readwrite) UILabel *describeLabel;

@property (nonatomic, strong) UIView *viewVoucher;  //代金券页面
@property (nonatomic, strong) UIView *viewDetail;   //使用细则页面

@end

@implementation MLVoucherTableViewCell

+ (CGFloat)height {
	return 100.5;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
        [self createViewVoucher];
        [self.contentView addSubview:self.viewVoucher];
	}
	return self;
}

- (void)setVoucher:(MLVoucher *)voucher {
	_voucher = voucher;
	if (_voucher) {
		_label.text = [NSString stringWithFormat:@"%@", _voucher.voucherWillGet];
		_describeLabel.text = [NSString stringWithFormat:@"此次购物成功后共获得%@元代金券", _voucher.voucherWillGet];
	}
}


- (void)createViewVoucher {
    if (!self.viewVoucher) {
        self.viewVoucher = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.viewVoucher.backgroundColor = [UIColor clearColor];
        
        CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect rect = CGRectMake(0, 0, fullWidth, [[self class] height]);
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:rect];
        backgroundView.image = [UIImage imageNamed:@"VoucherBackground"];
        [self.viewVoucher addSubview:backgroundView];
        
        rect.size.width = 100;
        rect.size.height = 70;
        _label = [[UILabel alloc] initWithFrame:rect];
        _label.font = [UIFont systemFontOfSize:42];
        _label.textColor = [UIColor themeColor];
        _label.textAlignment = NSTextAlignmentRight;
        _label.text = @"120";
        [self.viewVoucher addSubview:_label];
        
        rect.origin.x = CGRectGetMaxX(_label.frame);
        rect.origin.y = 30;
        rect.size.width = 25;
        rect.size.height = 25;
        UILabel *moneySymbolLabel = [[UILabel alloc] initWithFrame:rect];
        moneySymbolLabel.text = @"元";
        moneySymbolLabel.textColor = [UIColor themeColor];
        moneySymbolLabel.font = [UIFont systemFontOfSize:15];
        [self.viewVoucher addSubview:moneySymbolLabel];
        
        rect.origin.x = CGRectGetMaxX(moneySymbolLabel.frame);
        rect.origin.y = 10;
        rect.size.width = fullWidth - rect.origin.x;
        rect.size.height = 40;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:rect];
        nameLabel.text = @"代金券";
        nameLabel.textColor = [UIColor colorWithRed:249/255.0f green:138/255.f blue:51/255.0f alpha:1.0f];
        nameLabel.font = [UIFont boldSystemFontOfSize:22];
        [self.viewVoucher addSubview:nameLabel];
        
        rect.origin.y = CGRectGetMaxY(nameLabel.frame) - 10;
        rect.size.height = 20;
        _describeLabel = [[UILabel alloc] initWithFrame:rect];
        _describeLabel.font = [UIFont systemFontOfSize:9];
        _describeLabel.textColor = nameLabel.textColor;
        [self.viewVoucher addSubview:_describeLabel];
        
        
        rect.origin.x = 0;
        rect.origin.y = CGRectGetMaxY(_label.frame);
        rect.size.width = fullWidth;
        rect.size.height = [[self class] height] - rect.origin.y;
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:rect];
        bottomLabel.text = @"点击翻开查看使用细则";
        bottomLabel.textColor = [UIColor themeColor];
        bottomLabel.font = _describeLabel.font;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self.viewVoucher addSubview:bottomLabel];
    }
}

- (void)createViewDetail {
    if (!self.viewDetail) {
        self.viewDetail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.viewDetail.backgroundColor = [UIColor colorWithRed:29/255.0f green:175/255.0f blue:175/255.0f alpha:1.0f];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ML_COMMON_EDGE_LEFT, 5, CGRectGetWidth(self.viewDetail.frame) - ML_COMMON_EDGE_LEFT - ML_COMMON_EDGE_RIGHT, CGRectGetHeight(self.viewDetail.frame) - 20)];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"① 购买赠代金券的商品，确认收货后可领取代金券\n② 领取代金券的订单不可申请退换货\n③ 代金券不可兑现，代金券支付的部分不开发票\n④ 代金券最终解释权归江苏魔力网络科技有限公司所有";
        [self.viewDetail addSubview:label];
        
        CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect rect;
        rect.origin.x = 0;
        rect.origin.y = CGRectGetMaxY(_label.frame);
        rect.size.width = fullWidth;
        rect.size.height = [[self class] height] - rect.origin.y;
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:rect];
        bottomLabel.text = @"点击翻开查看代金券余额";
        bottomLabel.textColor = [UIColor whiteColor];
        bottomLabel.font = _describeLabel.font;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self.viewDetail addSubview:bottomLabel];
    }
}

- (void)showDetail {
    if (self.isVoucherDetail) {
		[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
			_viewVoucher.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1.0, 0.0);
		} completion:^(BOOL finished) {
			[self.viewVoucher removeFromSuperview];
			[self createViewDetail];
			[self.contentView addSubview:self.viewDetail];
			_viewVoucher.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 0.0);
		}];
		
    }
    else {
		[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
			_viewDetail.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1.0, 0.0);
		} completion:^(BOOL finished) {
			[self.viewDetail removeFromSuperview];
			[self createViewVoucher];
			[self.contentView addSubview:self.viewVoucher];
			_viewDetail.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0.0, 0.0);
		}];
    }
}


@end
