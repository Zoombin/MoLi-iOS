//
//  MLGoodsPropertiesPickerViewController.m
//  MoLi
//
//  Created by zhangbin on 1/19/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGoodsPropertiesPickerViewController.h"
#import "MLGoodsPropertyCollectionViewCell.h"
#import "Header.h"
#import "MLGoodsRectangleCollectionViewCell.h"
#import "MLSigninViewController.h"
#import "MLDepositViewController.h"
#import "MLGoodsPrice.h"

static CGFloat const minimumInteritemSpacing = 5;

@interface MLGoodsPropertiesPickerViewController () <
UIAlertViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegate,
UITextFieldDelegate
>

@property (readwrite) NSArray *sectionClasses;
@property (readwrite) UIView *quantityView;
@property (readwrite) UITextField *quantityTextField;
@property (readwrite) UILabel *voucherLabel;
@property (readwrite) UIView *confirmView;
@property (readwrite) UIView *addCatview;
@property (readwrite) UIView *goPayview;
@property (readwrite) UIView *selecSpecview;
@property (readwrite) UIButton *styleAddCartButton;
@property (readwrite) UIButton *styleDirectlyBuyButton;
@property (readwrite) UILabel *priceValueLabel;
@property (readwrite) MLGoodsPrice *goodsPrice;

@end

@implementation MLGoodsPropertiesPickerViewController

+ (CGFloat)indent {
	return 40;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	CGFloat heightForQuantityView = 60;
	CGFloat heightForConfirmView = 50;
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	
	CGFloat startX = edgeInsets.left;
	CGRect rect = CGRectZero;
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.minimumInteritemSpacing = minimumInteritemSpacing;
	layout.minimumLineSpacing = 5;
	
	rect.origin.x = 0;
	rect.origin.y = 0;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = self.view.bounds.size.height - heightForConfirmView - heightForQuantityView;
	_collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.allowsMultipleSelection = YES;
	_collectionView.backgroundColor = [UIColor whiteColor];
	[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
	[self.view addSubview:_collectionView];
	
	rect.origin.x = 0;
	rect.origin.y = self.view.bounds.size.height - heightForQuantityView - heightForConfirmView;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = heightForQuantityView;
	_quantityView = [[UIView alloc] initWithFrame:rect];
    [_quantityView setBackgroundColor:[UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1]];
	[self.view addSubview:_quantityView];
	
	rect.origin.x = 0;
	rect.origin.y = 18;
	rect.size.width = 60;
	rect.size.height = 23;
	UILabel *label = [[UILabel alloc] initWithFrame:rect];
	label.text = @"数量:";
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor lightGrayColor];
	[_quantityView addSubview:label];
	
	rect.origin.x = CGRectGetMaxX(label.frame) - 8;
	rect.size.width = 23;
	rect.size.height = rect.size.width;
	UIButton *decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	decreaseButton.frame = rect;
	[decreaseButton setImage:[UIImage imageNamed:@"Minus"] forState:UIControlStateNormal];
	[decreaseButton setImage:[UIImage imageNamed:@"MinusHighlighted"] forState:UIControlStateHighlighted];
	[decreaseButton addTarget:self action:@selector(decrease) forControlEvents:UIControlEventTouchUpInside];
	[_quantityView addSubview:decreaseButton];
	
	rect.origin.x = CGRectGetMaxX(decreaseButton.frame);
	rect.size.width = 56;
	_quantityTextField = [[UITextField alloc] initWithFrame:rect];
	_quantityTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	_quantityTextField.layer.borderWidth = 0.5;
	_quantityTextField.textAlignment = NSTextAlignmentCenter;
	_quantityTextField.keyboardType = UIKeyboardTypeNumberPad;
	_quantityTextField.delegate = self;
	[_quantityView addSubview:_quantityTextField];
	
    UIImageView *lines = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_quantityView.frame), 1)];
    [lines setBackgroundColor:[UIColor colorWithRed:227.0/255 green:227.0/255 blue:227.0/255 alpha:1]];
    [_quantityView addSubview:lines];
    
	rect.origin.x = CGRectGetMaxX(_quantityTextField.frame);
	rect.size.width = decreaseButton.bounds.size.width;
	UIButton *increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	increaseButton.frame = rect;
	[increaseButton setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
	[increaseButton setImage:[UIImage imageNamed:@"PlusHighlighted"] forState:UIControlStateHighlighted];
	[increaseButton addTarget:self action:@selector(increase) forControlEvents:UIControlEventTouchUpInside];
	[_quantityView addSubview:increaseButton];
	
	rect.origin.x = CGRectGetMaxX(increaseButton.frame) + 10;
	rect.size.width = 90;
	_voucherLabel = [[UILabel alloc] initWithFrame:rect];
	_voucherLabel.textColor = [UIColor themeColor];
	_voucherLabel.font = [UIFont systemFontOfSize:12];
	[_quantityView addSubview:_voucherLabel];
	[self.view addSubview:_quantityView];
	
	rect.origin.x = startX;
	rect.origin.y = CGRectGetMaxY(_quantityView.frame);
	rect.size.width = self.view.bounds.size.width - rect.origin.x;
	rect.size.height = heightForConfirmView;
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addKindView:) name:ML_NOTIFICATION_IDENTIFIER_OPEN_GOODS_PROPERTIES object:nil];
    [self selectSpecView:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createUIs {
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addKindView:(NSNotification*)notification {
    MLGoodsPropertiesPickerViewStyle style = [notification.userInfo[ML_GOODS_PROPERTIES_PICKER_VIEW_STYLE_KEY] integerValue];
	if (style == MLGoodsPropertiesPickerViewStyleNormal) {//选择规格
		[self selectSpecView:NO];
		[self addCatView:YES];
	} else if (style == MLGoodsPropertiesPickerViewStyleAddCart) {//加入购物车
		[self selectSpecView:YES];
		[self addCatView:NO];
		_styleAddCartButton.hidden = NO;
		_styleDirectlyBuyButton.hidden = YES;
	} else {//直接购买
		[self selectSpecView:YES];
		[self addCatView:NO];
		_styleAddCartButton.hidden = YES;
		_styleDirectlyBuyButton.hidden = NO;
	}
}

- (void)addCatView:(BOOL)flag {
    if (_addCatview == nil) {
        _addCatview = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_quantityView.frame), CGRectGetMaxY(_quantityView.frame), CGRectGetWidth(_quantityView.frame), 50)];
        [_addCatview setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
		
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (CGRectGetHeight(_addCatview.frame)-20)/2, 70, 20)];
        priceLabel.text = @"总价金额:";
        priceLabel.backgroundColor = [UIColor clearColor];
        [priceLabel setFont:[UIFont systemFontOfSize:13]];
        [priceLabel setTextColor:[UIColor lightGrayColor]];
        [_addCatview addSubview:priceLabel];
		
		_priceValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+3, (CGRectGetHeight(_addCatview.frame) - 20) / 2, 100, 20)];
        _priceValueLabel.textColor = [UIColor themeColor];
        _priceValueLabel.backgroundColor = [UIColor clearColor];
        [_addCatview addSubview:_priceValueLabel];
		
		_styleAddCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _styleAddCartButton.frame = CGRectMake(CGRectGetWidth(_addCatview.frame) - 90 - 54, 0, 90, CGRectGetHeight(_addCatview.frame));
        [_styleAddCartButton setBackgroundColor:[UIColor themeColor]];
        [_styleAddCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _styleAddCartButton.showsTouchWhenHighlighted = YES;
        [_styleAddCartButton setTitle:@"确认添加" forState:UIControlStateNormal];
        [_styleAddCartButton addTarget:self action:@selector(confirmAdd) forControlEvents:UIControlEventTouchUpInside];
        [_addCatview addSubview:_styleAddCartButton];
		
		_styleDirectlyBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_styleDirectlyBuyButton.frame = CGRectMake(CGRectGetWidth(_addCatview.frame) - 90 - 54, 0, 90, CGRectGetHeight(_addCatview.frame));
		[_styleDirectlyBuyButton setBackgroundColor:[UIColor themeColor]];
		[_styleDirectlyBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_styleDirectlyBuyButton.showsTouchWhenHighlighted = YES;
		[_styleDirectlyBuyButton setTitle:@"确认购买" forState:UIControlStateNormal];
		[_styleDirectlyBuyButton addTarget:self action:@selector(confirmBuy) forControlEvents:UIControlEventTouchUpInside];
		[_addCatview addSubview:_styleDirectlyBuyButton];
		
		[self.view addSubview:_addCatview];
    }
    _addCatview.hidden = flag;
	[self updatePriceValueLabelAndVoucherLabel];
}

- (void)selectSpecView:(BOOL)flag {
    if (_selecSpecview == nil) {
        _selecSpecview = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_quantityView.frame), CGRectGetMaxY(_quantityView.frame), CGRectGetWidth(_quantityView.frame), 50)];
        [_selecSpecview setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.frame = CGRectMake(60, 5, 80, 36);
        buyButton.layer.cornerRadius = 4;
        buyButton.backgroundColor = [UIColor themeColor];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyButton setTitle:@"确认购买" forState:UIControlStateNormal];
        buyButton.showsTouchWhenHighlighted = YES;
        [buyButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [buyButton addTarget:self action:@selector(confirmBuy) forControlEvents:UIControlEventTouchUpInside];
        [_selecSpecview addSubview:buyButton];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(CGRectGetMaxX(buyButton.frame)+20, 5, 80, 36);
        addButton.layer.cornerRadius = buyButton.layer.cornerRadius;
        addButton.layer.borderWidth = 0.5;
        addButton.layer.borderColor = [[UIColor themeColor] CGColor];
        [addButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        addButton.showsTouchWhenHighlighted = YES;
        [addButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [addButton setTitle:@"确认添加" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(confirmAdd) forControlEvents:UIControlEventTouchUpInside];
        [_selecSpecview addSubview:addButton];
        [self.view addSubview:_selecSpecview];
    }
    _selecSpecview.hidden = flag;
}

- (void)updatePriceValueLabelAndVoucherLabel {
	if (_goodsPrice) {
		_priceValueLabel.text = [NSString stringWithFormat:@"¥%0.2f", [_goodsPrice.price floatValue] * [[_goods quantityInCart] integerValue]];
		_voucherLabel.text = [NSString stringWithFormat:@"赠送代金券:%0.2f", [_goodsPrice.voucher floatValue] * [[_goods quantityInCart] integerValue]];
	}
}

- (void)increase {
	_goods.quantityInCart = @(_goods.quantityInCart.integerValue + 1);
	_quantityTextField.text = [NSString stringWithFormat:@"%@", _goods.quantityInCart];
	[self updatePriceValueLabelAndVoucherLabel];
}

- (void)decrease {
	NSInteger quantity = _goods.quantityInCart.integerValue;
	quantity--;
	if (quantity > 0) {
		_goods.quantityInCart = @(quantity);
	}
	_quantityTextField.text = [NSString stringWithFormat:@"%@", _goods.quantityInCart];
	[self updatePriceValueLabelAndVoucherLabel];
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
	if (_goods) {
		_quantityTextField.text = [NSString stringWithFormat:@"%@", _goods.quantityInCart];
		NSMutableArray *classes = [NSMutableArray array];
		[classes addObject:[MLGoodsRectangleCollectionViewCell class]];
		for (int i = 0; i < _goods.goodsProperties.count; i++) {
			[classes addObject:[MLGoodsPropertyCollectionViewCell class]];
		}
		_sectionClasses = [NSArray arrayWithArray:classes];
	}
	for (Class class in _sectionClasses) {
		[_collectionView registerClass:class forCellWithReuseIdentifier:[class identifier]];
	}
	[_collectionView reloadData];
}

- (void)confirmBuy {
	if (![self checkBeforeAddAndBuy]) {
		return;
	}
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] prepareOrder:@[_goods] buyNow:YES addressID:nil withBlock:^(BOOL vip, NSDictionary *addressAttributes, NSDictionary *voucherAttributes, NSArray *multiGoodsWithError, NSArray *multiGoods, NSNumber *totalPrice, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			if (!vip) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还不是会员" message:@"马上去成为会员" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"成为会员", nil];
				[alertView show];
			}
		}
	}];
}

- (void)confirmAdd {
	if (![self checkBeforeAddAndBuy]) {
		return;
	}
	
	[self displayHUD:@"加载中..."];
	NSLog(@"_goods selectedAllProperties: %@", [_goods selectedAllProperties]);
	[[MLAPIClient shared] addCartWithGoods:_goods.ID properties:[_goods selectedAllProperties] number:@(1) withBlock:^(NSError *error) {
		if (!error) {
			[self displayHUDTitle:nil message:NSLocalizedString(@"成功加入购物车", nil) duration:0.5];
			[[NSNotificationCenter defaultCenter] postNotificationName:ML_NOTIFICATION_IDENTIFIER_SYNC_CART object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:ML_NOTIFICATION_IDENTIFIER_CLOSE_GOODS_PROPERTIES object:nil];
		} else {
			[self displayHUDTitle:nil message:error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]];
		}
	}];
}

- (BOOL)checkBeforeAddAndBuy {
	if (![_goods didSelectAllProperties]) {
		[self displayHUDTitle:nil message:@"选择所有属性"];
		return NO;
	}
	
	if (![[MLAPIClient shared] sessionValid]) {
		MLSigninViewController *signinViewController = [[MLSigninViewController alloc] initWithNibName:nil bundle:nil];
		[self presentViewController:[[UINavigationController alloc] initWithRootViewController:signinViewController] animated:YES completion:nil];
		return NO;
	}
	return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		MLDepositViewController *depositViewController = [[MLDepositViewController alloc] initWithNibName:nil bundle:nil];
		[self presentViewController:[[UINavigationController alloc] initWithRootViewController:depositViewController] animated:YES completion:nil];
	}
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSInteger number = [textField.text integerValue];
	if (number == 0) {
		number = 1;
	}
	if (_goodsPrice) {
		if (number > _goodsPrice.stock.integerValue) {
			number = _goodsPrice.stock.integerValue;
			[self displayHUDTitle:nil message:[NSString stringWithFormat:@"最大数量%d", number] duration:1];
		}
	}
	_goods.quantityInCart = @(number);
	_quantityTextField.text = [NSString stringWithFormat:@"%@", _goods.quantityInCart];
	[self updatePriceValueLabelAndVoucherLabel];
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	CGFloat height = [class height];
	CGFloat width = 0;
	if (class == [MLGoodsRectangleCollectionViewCell class]) {
		width = collectionView.bounds.size.width;
	} else if (class == [MLGoodsPropertyCollectionViewCell class]) {
		MLGoodsProperty *goodsProperties = _goods.goodsProperties[indexPath.section - 1];
		NSString *text = goodsProperties.values[indexPath.row];
		width = [MLGoodsPropertyCollectionViewCell widthForText:text];
	}
	return CGSizeMake(width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
	view.backgroundColor = [UIColor whiteColor];
	for (UIView *v in view.subviews) {
		[v removeFromSuperview];
	}
	Class class = _sectionClasses[indexPath.section];
	if (class == [MLGoodsPropertyCollectionViewCell class]) {
        UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), 15)];
        [imageLine setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1]];
        [view addSubview:imageLine];
		MLGoodsProperty *goodsProperty = _goods.goodsProperties[indexPath.section - 1];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imageLine.frame)+5, view.bounds.size.width, view.bounds.size.height - 14)];
		label.text = goodsProperty.name;
		label.textColor = [UIColor grayColor];
		[view addSubview:label];
        
	}
	return view;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
	Class class = _sectionClasses[section];
	if (class == [MLGoodsRectangleCollectionViewCell class]) {
		flowLayout.headerReferenceSize = CGSizeZero;
	} else {
		flowLayout.headerReferenceSize = CGSizeMake(collectionView.bounds.size.width, 40);
	}
	CGFloat gap = 15;
	return UIEdgeInsetsMake(gap, 10, gap, 62);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	Class class = _sectionClasses[section];
	if (class == [MLGoodsRectangleCollectionViewCell class]) {
		return 1;
	}
	MLGoodsProperty *property = _goods.goodsProperties[section - 1];
	return property.values.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return _sectionClasses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[class identifier] forIndexPath:indexPath];
	if (class == [MLGoodsRectangleCollectionViewCell class]) {
		MLGoodsRectangleCollectionViewCell *rectangleCell = (MLGoodsRectangleCollectionViewCell *)cell;
		rectangleCell.goods = _goods;
	} else if (class == [MLGoodsPropertyCollectionViewCell class]) {
		MLGoodsPropertyCollectionViewCell *PropertyCell = (MLGoodsPropertyCollectionViewCell *)cell;
		MLGoodsProperty *goodsProperty = _goods.goodsProperties[indexPath.section - 1];
		[PropertyCell setGoodsProperty:goodsProperty atIndexPath:indexPath];
		if (goodsProperty.selectedIndex) {
			PropertyCell.selected = goodsProperty.selectedIndex.integerValue == indexPath.row;
		}
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	MLGoodsProperty *property = _goods.goodsProperties[indexPath.section - 1];
	property.selectedIndex = @(indexPath.row);
	[collectionView reloadData];
	if ([_goods didSelectAllProperties]) {
		[[MLAPIClient shared] priceForGoods:_goods selectedProperties:[_goods selectedAllProperties] withBlock:^(NSDictionary *attributes, MLResponse *response) {
			if (response.success) {
				_goodsPrice = [[MLGoodsPrice alloc] initWithAttributes:attributes];
				[self textFieldDidEndEditing:_quantityTextField];
				[self updatePriceValueLabelAndVoucherLabel];
			}
		}];
	}
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	MLGoodsProperty *property = _goods.goodsProperties[indexPath.section - 1];
	if (property.selectedIndex.integerValue == indexPath.row) {
		property.selectedIndex = nil;
	}
	[collectionView reloadData];
}

@end
