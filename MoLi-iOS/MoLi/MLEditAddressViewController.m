//
//  MLEditAddressViewController.m
//  MoLi
//
//  Created by zhangbin on 1/13/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLEditAddressViewController.h"
#import "Header.h"
#import "MLProvincesViewController.h"
#import "MLProvince.h"
#import "MLCity.h"
#import "MLArea.h"

@interface MLEditAddressViewController () <MLProvincesViewControllerDelegate>

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) UITextField *nameTextField;
@property (readwrite) UITextField *mobileTextField;
@property (readwrite) UITextField *postcodeTextField;
@property (readwrite) UILabel *areaLabel;
@property (readwrite) UITextField *streetTextField;
@property (readwrite) UILabel *defaultAddressLabel;
@property (readwrite) UIButton *defaultButton;
@property (readwrite) MLProvince *pickedProvince;
@property (readwrite) MLCity *pickedCity;
@property (readwrite) MLArea *pickedArea;

@end

@implementation MLEditAddressViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	[self setLeftBarButtonItemAsBackArrowButton];
	
	if (_address) {
		self.title = @"编辑地址";
	} else {
		self.title = @"新增地址";
	}
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submit)];
	
	CGFloat heightOfSubmitButton = 50;
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 15, 0, 15);
	CGRect rect = self.view.bounds;
	rect.size.height = self.view.bounds.size.height - heightOfSubmitButton;
	CGFloat cornerRadius = 2;
	UIFont *labelFont = [UIFont systemFontOfSize:14];
	UIFont *textFieldFont = [UIFont systemFontOfSize:16];
	UIColor *labelTextColor = [UIColor fontGrayColor];
	UIColor	*textFieldTextColor = [UIColor blackColor];
	UIColor *borderColor = [UIColor borderGrayColor];
	UIColor *textFieldBackgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1.0f];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:rect];
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:_scrollView];
	
	rect.origin.x = edgeInsets.left;
	rect.origin.y = edgeInsets.top;
	rect.size.width = self.view.bounds.size.width - edgeInsets.left - edgeInsets.right;
	rect.size.height = 35;
	
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:rect];
	nameLabel.text = @"收货人姓名";
	nameLabel.font = labelFont;
	nameLabel.textColor = labelTextColor;
	[_scrollView addSubview:nameLabel];
	
	rect.origin.y = CGRectGetMaxY(nameLabel.frame) + edgeInsets.bottom;
	_nameTextField = [[UITextField alloc] initWithFrame:rect];
	_nameTextField.font = textFieldFont;
	_nameTextField.textColor = textFieldTextColor;
	_nameTextField.layer.borderWidth = 0.5;
	_nameTextField.layer.borderColor = borderColor.CGColor;
	_nameTextField.backgroundColor = textFieldBackgroundColor;
	_nameTextField.layer.cornerRadius = cornerRadius;
	[_scrollView addSubview:_nameTextField];
	
	rect.origin.y = CGRectGetMaxY(_nameTextField.frame) + edgeInsets.bottom;
	UILabel *mobileLabel = [[UILabel alloc] initWithFrame:rect];
	mobileLabel.text = @"收货人手机";
	mobileLabel.font = labelFont;
	mobileLabel.textColor = labelTextColor;
	[_scrollView addSubview:mobileLabel];
	
	rect.origin.y = CGRectGetMaxY(mobileLabel.frame) + edgeInsets.bottom;
	_mobileTextField = [[UITextField alloc] initWithFrame:rect];
	_mobileTextField.font = textFieldFont;
	_mobileTextField.textColor = textFieldTextColor;
	_mobileTextField.layer.borderWidth = 0.5;
	_mobileTextField.layer.borderColor = borderColor.CGColor;
	_mobileTextField.backgroundColor = textFieldBackgroundColor;
	_mobileTextField.layer.cornerRadius = cornerRadius;
	[_scrollView addSubview:_mobileTextField];
	
	rect.origin.y = CGRectGetMaxY(_mobileTextField.frame) + edgeInsets.bottom;
	UILabel *postcodeLabel = [[UILabel alloc] initWithFrame:rect];
	postcodeLabel.text = @"邮政编码";
	postcodeLabel.font = labelFont;
	postcodeLabel.textColor = labelTextColor;
	[_scrollView addSubview:postcodeLabel];
	
	rect.origin.y = CGRectGetMaxY(postcodeLabel.frame) + edgeInsets.bottom;
	_postcodeTextField = [[UITextField alloc] initWithFrame:rect];
	_postcodeTextField.font = textFieldFont;
	_postcodeTextField.textColor = textFieldTextColor;
	_postcodeTextField.layer.borderWidth = 0.5;
	_postcodeTextField.layer.borderColor = borderColor.CGColor;
	_postcodeTextField.backgroundColor = textFieldBackgroundColor;
	_postcodeTextField.layer.cornerRadius = cornerRadius;
	[_scrollView addSubview:_postcodeTextField];
	
	rect.origin.y = CGRectGetMaxY(_postcodeTextField.frame) + edgeInsets.bottom;
	UILabel *areaLabel = [[UILabel alloc] initWithFrame:rect];
	areaLabel.text = @"所在地区";
	areaLabel.font = labelFont;
	areaLabel.textColor = labelTextColor;
	[_scrollView addSubview:areaLabel];
	
	rect.origin.y = CGRectGetMaxY(areaLabel.frame) + edgeInsets.bottom;
	_areaLabel = [[UILabel alloc] initWithFrame:rect];
	_areaLabel.font = textFieldFont;
	_areaLabel.textColor = textFieldTextColor;
	_areaLabel.layer.borderWidth = 0.5;
	_areaLabel.layer.borderColor = borderColor.CGColor;
	_areaLabel.backgroundColor = textFieldBackgroundColor;
	_areaLabel.layer.cornerRadius = cornerRadius;
	[_scrollView addSubview:_areaLabel];
	_areaLabel.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editArea)];
	[_areaLabel addGestureRecognizer:tap];
	
	rect.origin.y = CGRectGetMaxY(_areaLabel.frame) + edgeInsets.bottom;
	UILabel *addressLabel = [[UILabel alloc] initWithFrame:rect];
	addressLabel.text = @"详情地址";
	addressLabel.font = labelFont;
	addressLabel.textColor = labelTextColor;
	[_scrollView addSubview:addressLabel];
	
	rect.origin.y = CGRectGetMaxY(addressLabel.frame) + edgeInsets.bottom;
	rect.size.height = 60;
	_streetTextField = [[UITextField alloc] initWithFrame:rect];
	_streetTextField.font = textFieldFont;
	_streetTextField.textColor = textFieldTextColor;
	_streetTextField.layer.borderWidth = 0.5;
	_streetTextField.layer.borderColor = borderColor.CGColor;
	_streetTextField.backgroundColor = textFieldBackgroundColor;
	_streetTextField.layer.cornerRadius = cornerRadius;
	[_scrollView addSubview:_streetTextField];
	
	rect.origin.y = CGRectGetMaxY(_streetTextField.frame) + edgeInsets.bottom;
	rect.size.height = 30;
	_defaultAddressLabel = [[UILabel alloc] initWithFrame:rect];
	_defaultAddressLabel.text = @"设为默认地址";
	_defaultAddressLabel.font = labelFont;
	_defaultAddressLabel.textColor = labelTextColor;
	[_scrollView addSubview:_defaultAddressLabel];
	
	rect.size.width = 40;
	rect.size.height = 40;
	rect.origin.x = self.view.bounds.size.width - rect.size.width - edgeInsets.right;
	rect.origin.y -= 5;
	_defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_defaultButton.frame = rect;
	[_defaultButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
	[_defaultButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
	[_defaultButton addTarget:self action:@selector(setDefault:) forControlEvents:UIControlEventTouchUpInside];
	[_scrollView addSubview:_defaultButton];
	
	_scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, CGRectGetMaxY(_defaultButton.frame) + 50);
	
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = heightOfSubmitButton;
	rect.origin.x = 0;
	rect.origin.y = self.view.bounds.size.height - rect.size.height;
	UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
	saveButton.frame = rect;
	[saveButton setTitle:@"保存修改" forState:UIControlStateNormal];
	saveButton.showsTouchWhenHighlighted = YES;
	[saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	saveButton.backgroundColor = [UIColor themeColor];
	[saveButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:saveButton];
	
	if (_address) {
        BOOL isDefault = [_address.isDefault integerValue] == 1;
        if (isDefault) {
            _defaultButton.hidden = YES;
            _defaultAddressLabel.hidden = YES;
        }
		[[MLAPIClient shared] detailsOfAddress:_address.ID withBlock:^(NSDictionary *attributes, NSString *message, NSError *error) {
			if (!error) {
				if (message.length) {
					[self displayHUDTitle:nil message:message];
				} else {
					[self hideHUD:YES];
				}
				_address = [[MLAddress alloc] initWithAttributes:attributes];
                MLProvince *province = [[MLProvince alloc] init];
                province.ID = _address.provinceID;
                province.name = _address.province;
                _pickedProvince = province;
                
                MLCity *city = [[MLCity alloc] init];
                city.ID = _address.cityID;
                city.name = _address.city;
                _pickedCity = city;
                
                MLArea *area = [[MLArea alloc] init];
                area.ID = _address.areaID;
                area.name = _address.area;
                _pickedArea = area;
                
				_nameTextField.text = _address.name;
				_mobileTextField.text = _address.mobile;
				_postcodeTextField.text = _address.postcode;
				_areaLabel.text = [NSString stringWithFormat:@"%@%@%@", _address.province, _address.city, _address.area];
				_streetTextField.text = _address.street;
                _address.isDefault = isDefault ? @(1) : @(0);
                [_defaultButton setSelected:isDefault];
			} else {
				[self displayHUDTitle:nil message:[error MLErrorDesc]];
			}
		}];
	} else {
		_address = [[MLAddress alloc] init];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self allHidden];
}

- (void)allHidden {
    [_nameTextField resignFirstResponder];
    [_mobileTextField resignFirstResponder];
    [_postcodeTextField resignFirstResponder];
    [_streetTextField resignFirstResponder];
}

- (void)editArea {
	[self allHidden];
	MLProvincesViewController *provincesViewController = [[MLProvincesViewController alloc] initWithNibName:nil bundle:nil];
	provincesViewController.delegate = self;
	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:provincesViewController] animated:YES completion:nil];
}

- (void)setDefault:(UIButton *)sender {
	if (_address.isDefault.boolValue) {
		_address.isDefault = @(0);
	} else {
		_address.isDefault = @(1);
	}
	sender.selected = _address.isDefault.boolValue;
}

- (void)submit {
	if (!_nameTextField.text.length) {
		[self displayHUDTitle:nil message:@"请填写姓名"];
		return;
	}
	
	if (!_mobileTextField.text.length) {
		[self displayHUDTitle:nil message:@"请填写手机"];
		return;
	}
	
	if (!_postcodeTextField.text.length) {
		[self displayHUDTitle:nil message:@"请填写邮编"];
		return;
	}
	
	if (!_pickedProvince || !_pickedCity || !_pickedArea) {
		[self displayHUDTitle:nil message:@"请选择地区"];
		return;
	}
	
	if (!_streetTextField.text.length) {
		[self displayHUDTitle:nil message:@"请填写详细地址"];
		return;
	}
	
	_address.provinceID = _pickedProvince.ID;
	_address.cityID = _pickedCity.ID;
	_address.areaID = _pickedArea.ID;
	_address.street = _streetTextField.text;
	_address.postcode = _postcodeTextField.text;
	_address.name = _nameTextField.text;
	_address.phone = _mobileTextField.text;
	_address.mobile = _mobileTextField.text;

	[self displayHUD:@"保存中..."];
	[[MLAPIClient shared] addAddress:_address withBlock:^(NSString *message, NSError *error) {
		if (!error) {
			if (message.length) {
				[self displayHUDTitle:nil message:message];
			}
			[self performSelector:@selector(back) withObject:nil afterDelay:1];
		} else {
			[self displayHUDTitle:nil message:[error MLErrorDesc]];
		}
	}];
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MLProvincesViewControllerDelegate

- (void)pickProvince:(MLProvince *)provice city:(MLCity *)city area:(MLArea *)area {
	_pickedProvince = provice;
	_pickedCity = city;
	_pickedArea = area;
	_areaLabel.text = [NSString stringWithFormat:@"%@%@%@", provice.name, city.name, area.name];
}

@end
