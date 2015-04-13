//
//  MLGoodsDetailsViewController.m
//  MoLi
//
//  Created by zhangbin on 12/20/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoodsDetailsViewController.h"
#import "Header.h"
#import "MLGoodsProperty.h"
#import "MLGoodsImagesDetailsViewController.h"
#import "MLGalleryCollectionViewCell.h"
#import "MLGoodsInfoCollectionViewCell.h"
#import "MLCommonCollectionViewCell.h"
#import "MLGoodsCollectionViewCell.h"
#import "MLGoodsIntroduceCollectionViewCell.h"
#import "MLSigninViewController.h"
#import "MLFlagStoreCollectionViewCell.h"
#import "MLFlagshipStore.h"
#import "MLVoucher.h"
#import "MLVoucherCollectionViewCell.h"
#import "MLFlagshipStoreViewController.h"
#import "MLSigninViewController.h"
#import "MLPrepareOrderViewController.h"
#import "MLMemberCard.h"
#import "MLDepositViewController.h"
#import "MLCache.h"
#import "CDRTranslucentSideBar.h"

static CGFloat const heightOfAddCartView = 50;
static CGFloat const heightOfTabBar = 49;
static CGFloat const minimumInteritemSpacing = 18;

@interface MLGoodsDetailsViewController () <
MLGoodsInfoCollectionViewCellDelegate,
CDRTranslucentSideBarDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (readwrite) CDRTranslucentSideBar *rightSideBar;
@property (readwrite) UICollectionView *collectionView;
@property (readwrite) UILabel *headerLabel;
@property (readwrite) UIView *introduceView;
@property (readwrite) UILabel *introduceLabel;
@property (readwrite) UIScrollView *galleryScrollView;
@property (readwrite) UIView *addCartView;
@property (readwrite) NSMutableArray *sectionClasses;
@property (readwrite) NSArray *relatedMultiGoods;
@property (readwrite) BOOL showIndroduce;
@property (readwrite) MLFlagshipStore *flagshipStore;
@property (readwrite) MLVoucher *voucher;
@property (readwrite) CGRect addCartViewOriginRect;
@property (readwrite) UIImageView *arrowUpImageView;
@property (readwrite) UIButton *buyButton;
@property (readwrite) UIView *shadowView;

@end

@implementation MLGoodsDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	
	_sectionClasses = [@[[MLGalleryCollectionViewCell class],
						[MLGoodsInfoCollectionViewCell class],
						[MLCommonCollectionViewCell class],
						[MLCommonCollectionViewCell class],
						[MLGoodsIntroduceCollectionViewCell class],
						[MLCommonCollectionViewCell class],
						[MLFlagStoreCollectionViewCell class],
						[MLVoucherCollectionViewCell class],
						[MLGoodsCollectionViewCell class]
						] mutableCopy];
	
	CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - heightOfAddCartView);
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	_collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.backgroundColor = self.view.backgroundColor;
	for (int i = 0; i < _sectionClasses.count; i++) {
		Class class = _sectionClasses[i];
		[_collectionView registerClass:class forCellWithReuseIdentifier:[class identifier]];
	}
	[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"goodsCollection"];
	[self.view addSubview:_collectionView];
	
	rect.origin.x = 0;
	rect.origin.y = self.view.frame.size.height - heightOfAddCartView;
	rect.size.width = self.view.frame.size.width;
	rect.size.height = heightOfAddCartView;
	_addCartViewOriginRect = rect;
	_addCartView = [[UIView alloc] initWithFrame:rect];
	_addCartView.opaque = YES;
	_addCartView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
	[self.view addSubview:_addCartView];
	
	rect.origin.y = 0;
	rect.size.width = (self.view.frame.size.width - heightOfAddCartView) / 2;
	UIButton *addCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
	addCartButton.frame = rect;
	[addCartButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[addCartButton setTitle:NSLocalizedString(@"加入购物车", nil) forState:UIControlStateNormal];
	[addCartButton addTarget:self action:@selector(willOpenPropertiesPicker:) forControlEvents:UIControlEventTouchUpInside];
	[_addCartView addSubview:addCartButton];

	rect.origin.x = CGRectGetMaxX(addCartButton.frame);
	_buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_buyButton.frame = rect;
	_buyButton.backgroundColor = [UIColor themeColor];
	[_buyButton setTitle:NSLocalizedString(@"立即购买", nil) forState:UIControlStateNormal];
	[_buyButton addTarget:self action:@selector(willOpenPropertiesPicker:) forControlEvents:UIControlEventTouchUpInside];
	[_addCartView addSubview:_buyButton];
	
	rect.origin.x = CGRectGetMaxX(_buyButton.frame);
	rect.size.width = heightOfAddCartView;
	UIButton *hideAddCartViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
	hideAddCartViewButton.frame = rect;
	[hideAddCartViewButton setImage:[UIImage imageNamed:@"Girl"] forState:UIControlStateNormal];
	[hideAddCartViewButton addTarget:self action:@selector(fallOrRiseAddCartView) forControlEvents:UIControlEventTouchUpInside];
	[_addCartView addSubview:hideAddCartViewButton];
	
	_introduceLabel = [[UILabel alloc] init];
	_introduceLabel.numberOfLines = 0;
	_introduceLabel.font = [UIFont systemFontOfSize:15];
	_introduceLabel.textColor = [UIColor fontGrayColor];
	_introduceLabel.backgroundColor = _collectionView.backgroundColor;
	
	_introduceView = [[UIView alloc] init];
	_introduceView.backgroundColor = _collectionView.backgroundColor;
	[_introduceView addSubview:_introduceLabel];
	
	UIImage *backImage = [UIImage imageNamed:@"Back"];
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(20, 32, backImage.size.width, backImage.size.height);
	[backButton setImage:backImage forState:UIControlStateNormal];
	backButton.showsTouchWhenHighlighted = YES;
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	
	UIImage *shareImage = [UIImage imageNamed:@"Share"];
	UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
	shareButton.frame = CGRectMake(self.view.bounds.size.width - 20 - shareImage.size.width, 32, shareImage.size.width, shareImage.size.height);
	[shareButton setImage:shareImage forState:UIControlStateNormal];
	shareButton.showsTouchWhenHighlighted = YES;
	[shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:shareButton];
	
	_arrowUpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowUp"]];
	_arrowUpImageView.frame = CGRectMake(0, 0, _arrowUpImageView.image.size.width, _arrowUpImageView.image.size.height);
	
	_propertiesPickerViewController = [[MLGoodsPropertiesPickerViewController alloc] initWithNibName:nil bundle:nil];
	[_propertiesPickerViewController createUIs];
	_rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirection:YES];
	_rightSideBar.delegate = self;
	[_rightSideBar setContentViewInSideBar:_propertiesPickerViewController.view];
	
	_shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
	_shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
	
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	[self.view addGestureRecognizer:panGestureRecognizer];
	
	NSLog(@"goods id: %@", _goods.ID);
    [MLCache addMoliGoods:_goods];

	[[MLAPIClient shared] goodsDetails:_goods.ID withBlock:^(NSDictionary *attributes, NSArray *multiAttributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			_goods = [[MLGoods alloc] initWithAttributes:attributes];
            
			_relatedMultiGoods = [MLGoods multiWithAttributesArray:multiAttributes];
			
			if ([response.data[@"store"] notNull]) {
				if ([response.data[@"store"][@"businessid"] notNull]) {
					_flagshipStore = [[MLFlagshipStore alloc] initWithAttributes:response.data[@"store"]];
				}
			}
			
			if (!_flagshipStore) {
				[_sectionClasses removeObject:[MLFlagStoreCollectionViewCell class]];
			}

			
			if ([response.data[@"isvoucher"] boolValue]) {
				_voucher = [[MLVoucher alloc] init];
				_voucher.imagePath = response.data[@"voucherimage"];
				_voucher.voucherWillGetRange = response.data[@"voucher"];
			} else {
				[_sectionClasses removeObject:[MLVoucherCollectionViewCell class]];
			}
			
			CGRect frame = CGRectZero;
			frame.origin.y = [MLGoodsIntroduceCollectionViewCell height];
			frame.size.width = _collectionView.bounds.size.width;
			frame.size.height = [MLGoodsIntroduceCollectionViewCell heightPerIntroduceElementLine ] * [_goods linesForMultiIntroduce];
			_introduceView.frame = frame;
			
			frame.origin.x = minimumInteritemSpacing;
			frame.origin.y = 0;
			frame.size.width = frame.size.width - 2 * frame.origin.x;
			_introduceLabel.frame = frame;
			_introduceLabel.text = [_goods formattedIntroduce];
			
			[_collectionView reloadData];
			
			[[MLAPIClient shared] goodsProperties:_goods.ID withBlock:^(NSArray *multiAttributes, NSError *error) {
				if (!error) {
					NSArray *goodsProperties = [MLGoodsProperty multiWithAttributesArray:multiAttributes];
					_goods.goodsProperties = [NSArray arrayWithArray:goodsProperties];
					_propertiesPickerViewController.goods = _goods;
				}
			}];
		}
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self fallAddCartView:YES];
}

- (void)willOpenPropertiesPicker:(UIButton *)sender {
	[self fallAddCartView:YES];
	if (![[MLAPIClient shared] sessionValid]) {
		[self goToLogin];
		return;
	}
	
	if (sender == _buyButton) {
		[[NSNotificationCenter defaultCenter] postNotificationName:ML_NOTIFICATION_IDENTIFIER_OPEN_GOODS_PROPERTIES object:nil userInfo:@{ML_GOODS_PROPERTIES_PICKER_VIEW_STYLE_KEY : @(MLGoodsPropertiesPickerViewStyleDirectlyBuy)}];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:ML_NOTIFICATION_IDENTIFIER_OPEN_GOODS_PROPERTIES object:nil userInfo:@{ML_GOODS_PROPERTIES_PICKER_VIEW_STYLE_KEY : @(MLGoodsPropertiesPickerViewStyleAddCart)}];
	}
	
	[_rightSideBar show];
}

- (void)goToLogin {
    MLSigninViewController *signinViewController = [[MLSigninViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:signinViewController] animated:YES completion:nil];
}

//- (void)buyDirectly {
//    if (![[MLAPIClient shared] sessionValid]) {
//        [self goToLogin];
//        return;
//    }
//	
//	[[NSNotificationCenter defaultCenter] postNotificationName:ML_NOTIFICATION_IDENTIFIER_OPEN_GOODS_PROPERTIES object:nil userInfo:@{ML_GOODS_PROPERTIES_PICKER_VIEW_STYLE_KEY : @(MLGoodsPropertiesPickerViewStyleDirectlyBuy)}];
//	
////    [self displayHUD:@"加载中..."];
////    [[MLAPIClient shared] memeberCardWithBlock:^(NSDictionary *attributes, MLResponse *response) {
////        [self displayResponseMessage:response];
////        if (response.success) {
////            NSLog(@"是会员");
////            MLMemberCard *memberCard = [[MLMemberCard alloc] initWithAttributes:attributes];
////            if ([memberCard isVIP].boolValue) {
////                [self buyMultiGoods];
////            } else {
////                NSLog(@"不是会员");
////                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还不是会员" message:@"马上去成为会员" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"成为会员", nil];
////                [alertView show];
////            }
////        }
////    }];
//}

- (void)buyMultiGoods {
    [self displayHUD:@"加载中..."];
    [[MLAPIClient shared] prepareOrder:@[_goods] buyNow:NO addressID:nil withBlock:^(BOOL vip, NSDictionary *addressAttributes, NSDictionary *voucherAttributes, NSArray *multiGoodsWithError, NSArray *multiGoods, NSNumber *totalPrice, MLResponse *response) {
        [self displayResponseMessage:response];
        if (response.success) {
            if (!vip) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还不是会员" message:@"现在就加入会员吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在加入", nil];
                [alertView show];
                return;
            }
            
            if (!multiGoodsWithError.count) {
                MLPrepareOrderViewController *prepareOrderViewController = [[MLPrepareOrderViewController alloc] initWithNibName:nil bundle:nil];
                prepareOrderViewController.hidesBottomBarWhenPushed = YES;
                prepareOrderViewController.multiGoods = @[_goods];
                [self.navigationController pushViewController:prepareOrderViewController animated:YES];
                return;
            } else {
                NSArray *noStorageMultiGoods = [MLGoods multiWithAttributesArray:multiGoodsWithError];
                NSArray *allGoods = @[_goods];
                for	(MLGoods *g in noStorageMultiGoods) {
                    for (MLGoods *goods in allGoods) {
                        if ([g sameGoodsWithSameSelectedProperties:goods]) {
                            goods.hasStorage = @(NO);
                        }
                    }
                }
                return;
            }
        }
    }];
}

- (void)fallOrRiseAddCartView {
	[self fallAddCartView:!self.tabBarController.tabBar.hidden];
}

- (void)fallAddCartView:(BOOL)fall {
	self.tabBarController.tabBar.hidden = fall;
	CGRect rect = _addCartViewOriginRect;
	if (!fall) {
		rect.origin.y -= heightOfTabBar;
	}
	_addCartView.frame = rect;
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)share {
	[[MLAPIClient shared] shareWithObject:MLShareObjectGoods platform:MLSharePlatformQQ objectID:_goods.ID withBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			MLShare *share = [[MLShare alloc] initWithAttributes:attributes];
			[UMSocialSnsService presentSnsIconSheetView:self appKey:ML_UMENG_APP_KEY shareText:share.word shareImage:[UIImage imageNamed:@"MoliIcon"] shareToSnsNames:@[UMShareToSina, UMShareToQzone, UMShareToQQ, UMShareToWechatTimeline, UMShareToWechatSession] delegate:nil];
		}
	}];
}

#pragma mark - MLGoodsInfoCollectionViewCellDelegate

- (void)goods:(MLGoods *)goods farovite:(BOOL)favorite {
	if (![[MLAPIClient shared] sessionValid]) {
		MLSigninViewController *signinViewController = [[MLSigninViewController alloc] initWithNibName:nil bundle:nil];
		[self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:signinViewController] animated:YES completion:nil];
		return;
	}
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] goods:goods.ID favour:favorite withBlock:^(NSString *message, NSError *error) {
		if (!error) {
			if (message.length) {
				[self displayHUDTitle:nil message:message];
			} else {
				[self hideHUD:YES];
			}
			_goods.favorited = @(favorite);
			[_collectionView reloadData];
		} else {
			[self displayHUDTitle:nil message:error.userInfo[ML_ERROR_MESSAGE_IDENTIFIER]];
		}
	}];
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
	Class class = _sectionClasses[indexPath.section];
	CGFloat height = [class height];
	CGFloat width = collectionView.bounds.size.width;
	flowLayout.headerReferenceSize = CGSizeMake(collectionView.bounds.size.width, 5);
	if (class == [MLGoodsCollectionViewCell class]) {
		flowLayout.headerReferenceSize = CGSizeMake(collectionView.bounds.size.width, 40);
		width = [class size].width;
	} else if (class == [MLGoodsIntroduceCollectionViewCell class]) {
		if (_showIndroduce) {
			height += [MLGoodsIntroduceCollectionViewCell heightPerIntroduceElementLine] * [_goods linesForMultiIntroduce];
		}
	}
	return CGSizeMake(width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	NSString *identifier = @"Header";
	UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
	if (class == [MLGoodsCollectionViewCell class]) {
        
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"goodsCollection" forIndexPath:indexPath];
        if (_headerLabel) {
            [_headerLabel removeFromSuperview];
            _headerLabel = nil;
        }
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(ML_COMMON_EDGE_LEFT, 5, collectionView.bounds.size.width - ML_COMMON_EDGE_LEFT - ML_COMMON_EDGE_RIGHT, 40)];
        _headerLabel.text = @"猜你喜欢";
        _headerLabel.font = [UIFont systemFontOfSize:16];
        _headerLabel.textColor = [UIColor fontGrayColor];
        [view addSubview:_headerLabel];
	}
	return view;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	Class class = _sectionClasses[section];
    
	if (class == [MLGoodsCollectionViewCell class]) {
		NSInteger numberPerLine = 2;
		CGFloat itemWidth = [class size].width;
		CGFloat gap = [NSNumber edgeWithMaxWidth:collectionView.bounds.size.width itemWidth:itemWidth numberPerLine:numberPerLine].floatValue;
		return UIEdgeInsetsMake(10, gap, 10, gap);
	}
	return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	Class class = _sectionClasses[section];
	if (class == [MLGoodsCollectionViewCell class]) {
		return _relatedMultiGoods.count;
	}
	return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return _sectionClasses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[class identifier] forIndexPath:indexPath];
	cell.backgroundColor = [UIColor whiteColor];
	if (class == [MLGalleryCollectionViewCell class]) {
		MLGalleryCollectionViewCell	*galleryCell = (MLGalleryCollectionViewCell *)cell;
		galleryCell.imagePaths = _goods.gallery;
	} else if (class == [MLGoodsInfoCollectionViewCell class]) {
		MLGoodsInfoCollectionViewCell *infoCell = (MLGoodsInfoCollectionViewCell *)cell;
		infoCell.goods = _goods;
		infoCell.delegate = self;
	} else  if (class == [MLCommonCollectionViewCell class]) {
		MLCommonCollectionViewCell *commonCell = (MLCommonCollectionViewCell *)cell;
        if (indexPath.section == 1) {
            commonCell.imagedirection.hidden = NO;
        }else if (indexPath.section == 2) {
			commonCell.text = [NSString stringWithFormat:@"选择:%@", _goods.choose ?: @""];
            commonCell.imagedirection.hidden = NO;
		} else if (indexPath.section == 3) {
			commonCell.text = @"图文详情";
            commonCell.imagedirection.hidden = NO;
			commonCell.image = [UIImage imageNamed:@"ImagesDetails"];
        }else if (indexPath.section == 5) {
			NSString *text = [NSString stringWithFormat:@"累计评价(%@)", _goods.commentsNumber];
			NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
            commonCell.imagedirection.hidden = NO;
			[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor themeColor] range:NSMakeRange(4, text.length - 4)];
			commonCell.attributedText = attributedString;
			commonCell.image = [UIImage imageNamed:@"Like"];
		}
	} else if (class == [MLGoodsIntroduceCollectionViewCell class]) {
		MLGoodsIntroduceCollectionViewCell *introduceCell = (MLGoodsIntroduceCollectionViewCell *)cell;
		introduceCell.text = @"规格参数";
		introduceCell.image = [UIImage imageNamed:@"Parameters"];
        introduceCell.imagedirection.hidden = NO;
		
		if (_showIndroduce) {
			[introduceCell.contentView addSubview:_introduceView];
			CGRect rect = _arrowUpImageView.frame;
			rect.origin.x = 15;
			rect.origin.y = [MLGoodsIntroduceCollectionViewCell height] - rect.size.height;
			_arrowUpImageView.frame = rect;
			[introduceCell addSubview:_arrowUpImageView];
		} else {
			[_introduceView removeFromSuperview];
			[_arrowUpImageView removeFromSuperview];
		}
	} else if (class == [MLFlagStoreCollectionViewCell class]) {
		MLFlagStoreCollectionViewCell *flagStoreCell = (MLFlagStoreCollectionViewCell *)cell;
		flagStoreCell.backgroundColor = [UIColor redColor];
		[flagStoreCell.imageView setImageWithURL:[NSURL URLWithString:_flagshipStore.iconPath]];
		flagStoreCell.text = _flagshipStore.name;
	} else if (class == [MLVoucherCollectionViewCell class]) {
		MLVoucherCollectionViewCell *voucherCell = (MLVoucherCollectionViewCell *)cell;
		voucherCell.voucher = _voucher;
		voucherCell.backgroundColor = [UIColor clearColor];
	} else if (class == [MLGoodsCollectionViewCell class]) {
		MLGoods *goods = _relatedMultiGoods[indexPath.row];
		MLGoodsCollectionViewCell *goodsCell = (MLGoodsCollectionViewCell *)cell;
		goodsCell.goods = goods;
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.tabBarController.tabBar.hidden) {
		[self fallAddCartView:YES];
		return;
	}
	Class class = _sectionClasses[indexPath.section];
	if (class == [MLGoodsIntroduceCollectionViewCell class]) {
		_showIndroduce = !_showIndroduce;
		[_collectionView reloadData];
	} else if (class == [MLCommonCollectionViewCell class]) {
		if (indexPath.section == 2) {//选择
            [[NSNotificationCenter defaultCenter] postNotificationName:ML_NOTIFICATION_IDENTIFIER_OPEN_GOODS_PROPERTIES object:nil userInfo:@{ML_GOODS_PROPERTIES_PICKER_VIEW_STYLE_KEY : @(MLGoodsPropertiesPickerViewStyleNormal)}];
			[_rightSideBar show];
		} else if (indexPath.section == 3) {//图文详情
			MLGoodsImagesDetailsViewController *imagesDetailsViewController = [[MLGoodsImagesDetailsViewController alloc] initWithNibName:nil bundle:nil];
			imagesDetailsViewController.goods = _goods;
			imagesDetailsViewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:imagesDetailsViewController animated:YES];
        }else if (indexPath.section == 5){//累计评价
        
        
        }
	} else if (class == [MLFlagStoreCollectionViewCell class]) {
		MLFlagshipStoreViewController *flagshipStoreViewController = [[MLFlagshipStoreViewController alloc] initWithNibName:nil bundle:nil];
		flagshipStoreViewController.flagshipStore = _flagshipStore;
		flagshipStoreViewController.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:flagshipStoreViewController animated:YES];
	} else if (class == [MLGoodsCollectionViewCell class]) {
		MLGoods *goods = _relatedMultiGoods[indexPath.row];
		MLGoodsDetailsViewController *goodsDetailsViewController = [[MLGoodsDetailsViewController alloc] initWithNibName:nil bundle:nil];
		NSLog(@"goods: %@", goods);
		goodsDetailsViewController.goods = goods;
		[self.navigationController pushViewController:goodsDetailsViewController animated:YES];
	}
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	if (class == [MLGoodsIntroduceCollectionViewCell class]) {
		_showIndroduce = !_showIndroduce;
		[_collectionView reloadData];
	}
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        MLDepositViewController *depositViewController = [[MLDepositViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:depositViewController] animated:YES completion:nil];
    }
}

#pragma mark - Gesture Handler

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
	// if you have left and right sidebar, you can control the pan gesture by start point.
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		CGPoint startPoint = [recognizer locationInView:self.view];
		// Left SideBar
		if (startPoint.x < self.view.bounds.size.width / 2.0) {
			//            self.sideBar.isCurrentPanGestureTarget = YES;
		}
		// Right SideBar
		else {
			self.rightSideBar.isCurrentPanGestureTarget = YES;
		}
	}
	[self.rightSideBar handlePanGestureToShow:recognizer inView:self.view];
}

#pragma mark - CDRTranslucentSideBarDelegate

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated {
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated {
	[self.view addSubview:_shadowView];
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated {
	[_shadowView removeFromSuperview];
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated {
}


@end
