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
#import "IIViewDeckController.h"
#import "MLDepositViewController.h"

static CGFloat const minimumInteritemSpacing = 5;

@interface MLGoodsPropertiesPickerViewController () <
UIAlertViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegate
>{

    UIView *addCatview;
    UIView *goPayview;
    UIView *selecSpecview;
    
}

@property (readwrite) NSArray *sectionClasses;
@property (readwrite) UIView *quantityView;
@property (readwrite) UILabel *quantityLabel;
@property (readwrite) UILabel *voucherLabel;
@property (readwrite) UIView *confirmView;

@end

@implementation MLGoodsPropertiesPickerViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (CGFloat)indent {
	return 40;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe)];
	[self.view addGestureRecognizer:swipeGestureRecognizer];
	
	CGFloat heightForQuantityView = 60;
	CGFloat heightForConfirmView = 50;
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, [[self class] indent] + 10, 0, 10);
	
	CGFloat startX = edgeInsets.left;
	CGRect rect = CGRectZero;
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.minimumInteritemSpacing = minimumInteritemSpacing;
	layout.minimumLineSpacing = 5;
	
	rect.origin.x = 30;
	rect.origin.y = 0;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = self.view.bounds.size.height - heightForConfirmView-heightForQuantityView;
	_collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.allowsMultipleSelection = YES;
	_collectionView.backgroundColor = [UIColor whiteColor];
	[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
	[self.view addSubview:_collectionView];
	
	rect.origin.x = 0;
	rect.origin.y = self.view.bounds.size.height - heightForQuantityView - heightForConfirmView;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = heightForQuantityView;
	_quantityView = [[UIView alloc] initWithFrame:rect];
    [_quantityView setBackgroundColor:[UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1]];
	[self.view addSubview:_quantityView];
	
	rect.origin.x = 50;
	rect.origin.y = 18;
	rect.size.width = 60;
	rect.size.height = 23;
	UILabel *label = [[UILabel alloc] initWithFrame:rect];
	label.text = @"数量:";
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor lightGrayColor];
	[_quantityView addSubview:label];
	
	rect.origin.x = CGRectGetMaxX(label.frame);
	rect.size.width = 23;
	rect.size.height = rect.size.width;
	UIButton *decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	decreaseButton.frame = rect;
	[decreaseButton setImage:[UIImage imageNamed:@"Minus"] forState:UIControlStateNormal];
	[decreaseButton setImage:[UIImage imageNamed:@"MinusHighlighted"] forState:UIControlStateHighlighted];
	[decreaseButton addTarget:self action:@selector(decrease) forControlEvents:UIControlEventTouchUpInside];
	[_quantityView addSubview:decreaseButton];
	
	rect.origin.x = CGRectGetMaxX(decreaseButton.frame);
	rect.size.width = 60;
	_quantityLabel = [[UILabel alloc] initWithFrame:rect];
//	_quantityLabel.backgroundColor = [UIColor blackColor];
//	_quantityLabel.text = @"1";
	_quantityLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	_quantityLabel.layer.borderWidth = 0.5;
	_quantityLabel.textAlignment = NSTextAlignmentCenter;
	[_quantityView addSubview:_quantityLabel];
	
    UIImageView *lines = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_quantityView.frame), 1)];
    [lines setBackgroundColor:[UIColor colorWithRed:227.0/255 green:227.0/255 blue:227.0/255 alpha:1]];
    [_quantityView addSubview:lines];
    
	rect.origin.x = CGRectGetMaxX(_quantityLabel.frame);
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
	_voucherLabel.text = @"赠送50元优惠券";
	_voucherLabel.textColor = [UIColor themeColor];
	_voucherLabel.font = [UIFont systemFontOfSize:12];
	[_quantityView addSubview:_voucherLabel];
	[self.view addSubview:_quantityView];
	
	rect.origin.x = startX;
	rect.origin.y = CGRectGetMaxY(_quantityView.frame);
	rect.size.width = self.view.bounds.size.width - rect.origin.x;
	rect.size.height = heightForConfirmView;
//    [_quantityView setBackgroundColor:[UIColor redColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addKindView:) name:@"selectKindView" object:nil];
    [self selectSpecView:NO];
}


-(void)addKindView:(NSNotification*)notification{
    int type = [notification.userInfo[@"type"] intValue];
    if (type==1) {
        //选择规格
        [self selectSpecView:NO];
        [self addCatView:YES];
        [self goPayView:YES];
    }else if (type==2){
        [self selectSpecView:YES];
        [self addCatView:NO];
        [self goPayView:YES];
    }
}



-(void)addCatView:(BOOL)flag{
    if (addCatview==nil) {
        addCatview = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_quantityView.frame), CGRectGetMaxY(_quantityView.frame), CGRectGetWidth(_quantityView.frame), 50)];
        [addCatview setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, (CGRectGetHeight(addCatview.frame)-20)/2, 70, 20)];
        priceLabel.text = @"总价金额:";
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.backgroundColor = [UIColor clearColor];
        [priceLabel setFont:[UIFont systemFontOfSize:13]];
        [priceLabel setTextColor:[UIColor lightGrayColor]];
        [addCatview addSubview:priceLabel];
        UILabel *priceValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+3, (CGRectGetHeight(addCatview.frame)-20)/2, 100, 20)];
        priceValue.text = @"￥3998.0";
        priceValue.textColor = [UIColor themeColor];
        priceValue.backgroundColor = [UIColor clearColor];
        [addCatview addSubview:priceValue];
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(CGRectGetWidth(addCatview.frame)-90, 0, 90, CGRectGetHeight(addCatview.frame));
        [addButton setBackgroundColor:[UIColor themeColor]];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addButton.showsTouchWhenHighlighted = YES;
        [addButton setTitle:@"确认添加" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(confirmAdd) forControlEvents:UIControlEventTouchUpInside];
        [addCatview addSubview:addButton];
        [self.view addSubview:addCatview];
    }
    addCatview.hidden = flag;
    
}

-(void)goPayView:(BOOL)flag{
    if (goPayview==nil) {
        goPayview = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_quantityView.frame), CGRectGetMaxY(_quantityView.frame), CGRectGetWidth(_quantityView.frame), 50)];
        [goPayview setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, (CGRectGetHeight(goPayview.frame)-20)/2, 70, 20)];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.text = @"总价金额:";
        priceLabel.backgroundColor = [UIColor clearColor];
        [priceLabel setFont:[UIFont systemFontOfSize:13]];
        [priceLabel setTextColor:[UIColor lightGrayColor]];
        [goPayview addSubview:priceLabel];
        UILabel *priceValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+3, (CGRectGetHeight(goPayview.frame)-20)/2, 100, 20)];
        priceValue.text = @"￥3998.0";
        priceValue.textColor = [UIColor themeColor];
        priceValue.backgroundColor = [UIColor clearColor];
        [goPayview addSubview:priceValue];
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.frame = CGRectMake(CGRectGetWidth(goPayview.frame)-90, 0, 90, CGRectGetHeight(goPayview.frame));
        [buyButton setBackgroundColor:[UIColor themeColor]];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyButton.showsTouchWhenHighlighted = YES;
        [buyButton setTitle:@"确认购买" forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(confirmBuy) forControlEvents:UIControlEventTouchUpInside];
        [goPayview addSubview:buyButton];
         [self.view addSubview:goPayview];
    }
     goPayview.hidden = flag;
}


-(void)selectSpecView:(BOOL)flag{
    
    if (selecSpecview==nil) {
//        CGRect rect = CGRectZero;
//        rect.size.width = CGRectGetWidth(_quantityView.frame);
//        rect.size.height = 50;
//        rect.origin.x = 3;
//        rect.origin.y = CGRectGetMaxY(_quantityView.frame);
        selecSpecview = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_quantityView.frame), CGRectGetMaxY(_quantityView.frame), CGRectGetWidth(_quantityView.frame), 50)];
        [selecSpecview setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
//        [selecSpecview setBackgroundColor:[UIColor yellowColor]];
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.frame = CGRectMake(60, 5, 80, 36);
        buyButton.layer.cornerRadius = 4;
        buyButton.backgroundColor = [UIColor themeColor];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyButton setTitle:@"确认购买" forState:UIControlStateNormal];
        buyButton.showsTouchWhenHighlighted = YES;
        [buyButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [buyButton addTarget:self action:@selector(confirmBuy) forControlEvents:UIControlEventTouchUpInside];
        [selecSpecview addSubview:buyButton];
        
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
        [selecSpecview addSubview:addButton];
        [self.view addSubview:selecSpecview];
        
    }
    
    selecSpecview.hidden = flag;

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)increase {
	_goods.quantityInCart = @(_goods.quantityInCart.integerValue + 1);
	_quantityLabel.text = [NSString stringWithFormat:@"%@", _goods.quantityInCart];
}

- (void)decrease {
	NSInteger quantity = _goods.quantityInCart.integerValue;
	quantity--;
	if (quantity > 0) {
		_goods.quantityInCart = @(quantity);
	}
	_quantityLabel.text = [NSString stringWithFormat:@"%@", _goods.quantityInCart];
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
	if (_goods) {
		_quantityLabel.text = [NSString stringWithFormat:@"%@", _goods.quantityInCart];
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
	[[MLAPIClient shared] prepareOrder:@[_goods] buyNow:YES withBlock:^(BOOL vip, NSDictionary *addressAttributes, NSDictionary *voucherAttributes, NSArray *multiGoodsWithError, NSArray *multiGoods, NSNumber *totalPrice, MLResponse *response) {
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

- (void)swipe {
	[self.viewDeckController toggleRightView];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		MLDepositViewController *depositViewController = [[MLDepositViewController alloc] initWithNibName:nil bundle:nil];
		[self presentViewController:[[UINavigationController alloc] initWithRootViewController:depositViewController] animated:YES completion:nil];
	}
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
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(imageLine.frame)+5, view.bounds.size.width, view.bounds.size.height - 14)];
//		label.backgroundColor = [UIColor blueColor];
		label.text = goodsProperty.name;
		label.textColor = [UIColor grayColor];
		[view addSubview:label];
        
	}
//    [view setBackgroundColor:[UIColor redColor]];
	return view;
    
//    UICollectionReusableView *viewfoter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Footer" forIndexPath:indexPath];
//    view.backgroundColor = [UIColor whiteColor];
    /*
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
//    Class class = _sectionClasses[indexPath.section];
//    if (class == [MLGoodsPropertyCollectionViewCell class]) {
//        MLGoodsProperty *goodsProperty = _goods.goodsProperties[indexPath.section - 1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, viewfoter.bounds.size.width, viewfoter.bounds.size.height - 14)];
        //		label.backgroundColor = [UIColor blueColor];
        label.text = goodsProperty.name;
        label.textColor = [UIColor grayColor];
        [viewfoter addSubview:label];
//    }
    
     */
//    return viewfoter;
    
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
	return UIEdgeInsetsMake(gap, gap+10, gap, gap);
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
//	cell.backgroundColor = [UIColor redColor];
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
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	MLGoodsProperty *property = _goods.goodsProperties[indexPath.section - 1];
	if (property.selectedIndex.integerValue == indexPath.row) {
		property.selectedIndex = nil;
	}
	[collectionView reloadData];
}

@end
