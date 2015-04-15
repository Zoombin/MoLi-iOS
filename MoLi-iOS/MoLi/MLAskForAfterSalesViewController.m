//
//  MLAskForAfterSalesViewController.m
//  MoLi
//
//  Created by zhangbin on 2/2/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAskForAfterSalesViewController.h"
#import "Header.h"
#import "MLAfterSalesGoodsTableViewCell.h"
#import "MLAddAddressTableViewCell.h"
#import "MLEditAddressViewController.h"
#import "MLAddress.h"
#import "MLAfterSalesInfoTableViewCell.h"
#import "MLAddressTableViewCell.h"
#import "MLGoodsOrderTableViewCell.h"
#import "MLAddressesViewController.h"

@interface MLAskForAfterSalesViewController () <
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
MLAfterSalesInfoTableViewCellDelegate,
UITableViewDataSource, UITableViewDelegate,
MLAddressTableViewCellDelegate
>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableArray *sectionClasses;
@property (readwrite) UIButton *submitButton;
@property (readwrite) MLAddress *address;
@property (readwrite) NSMutableArray *uploadedImagePaths;
@property (readwrite) NSMutableArray *uploadedImages;
@property (readwrite) MLAfterSalesType type;
@property (readwrite) NSString *reason;

@end

@implementation MLAskForAfterSalesViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"申请售后";
    [self setLeftBarButtonItemAsBackArrowButton];
    
	_type = MLAfterSalesTypeUnknow;
	_uploadedImages = [NSMutableArray array];
	_uploadedImagePaths = [NSMutableArray array];
	
	_sectionClasses = [@[
						 [MLAfterSalesGoodsTableViewCell class],
						 [MLAfterSalesInfoTableViewCell class],
						 [MLAddAddressTableViewCell class],
						 ] mutableCopy];
	
	CGRect rect = CGRectZero;
	CGFloat heightOfSubmitButton = 50;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = self.view.bounds.size.height - heightOfSubmitButton;
	_tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	rect.size.height = heightOfSubmitButton;
	rect.origin.y = self.view.bounds.size.height - heightOfSubmitButton;
	_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_submitButton.frame = rect;
	_submitButton.backgroundColor = [UIColor themeColor];
	[_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_submitButton setTitle:@"提交申请" forState:UIControlStateNormal];
	[_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_submitButton];
}

- (void)submit {
	if (_type == MLAfterSalesTypeUnknow) {
		[self displayHUDTitle:nil message:@"请选择售后类型"];
		return;
	}
	
	if (!_reason.length) {
		[self displayHUDTitle:nil message:@"请输入原因"];
		return;
	}
	
	[self displayHUDTitle:nil message:@"提交中..."];
	[[MLAPIClient shared] afterSalesAdd:_afterSalesGoods reason:_reason imagePaths:_uploadedImagePaths addressID:_address.ID withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	UIImagePickerController *controller = [self imagePickerForActionSheet:actionSheet withButtonIndex:buttonIndex];
	controller.allowsEditing = YES;
	if (controller) {
		controller.delegate = self;
		[self presentViewController:controller animated:YES completion:nil];
	}
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissViewControllerAnimated:YES completion:^{
		[self displayHUD:@"上传中..."];
		UIImage *image = info[UIImagePickerControllerOriginalImage];
		[[MLAPIClient shared] uploadImage:image withBlock:^(NSString *imagePath, MLResponse *response) {
			[self displayResponseMessage:response];
			if (response.success) {
				[_uploadedImagePaths addObject:imagePath];
				[_uploadedImages addObject:image];
				[_tableView reloadData];
			}
		}];
	}];
}

#pragma mark MLAfterSalesInfoTableViewCellDelegate

- (void)didSelectAfterSalesType:(MLAfterSalesType)type {
	_type = type;
    [self.tableView reloadData];
}

- (void)willAddPhoto {
	UIActionSheet *actionSheet = [UIActionSheet imagePickerActionSheet];
	actionSheet.delegate = self;
	[actionSheet showInView:self.view];
}

- (void)willDeletePhotoAtIndex:(NSInteger)index {
	[_uploadedImages removeObjectAtIndex:index];
	[_uploadedImagePaths removeObjectAtIndex:index];
	[_tableView reloadData];
}

- (void)didEndEditing:(NSString *)text {
	_reason = text;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
    if(indexPath.section==2&&self.address)
        class = [MLAddressTableViewCell class];
	return [class height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _sectionClasses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
    if(indexPath.section==2&&self.address)
        class = [MLAddressTableViewCell class];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[class identifier]];
	if (!cell) {
		cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[class identifier]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	if (class == [MLAfterSalesGoodsTableViewCell class]) {
		MLAfterSalesGoodsTableViewCell *goodsCell = (MLAfterSalesGoodsTableViewCell *)cell;
		goodsCell.afterSalesGoods = _afterSalesGoods;
        
        
//        MLGoodsOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MLGoodsOrderTableViewCell identifier]];
//        if (!cell) {
//            cell = [[MLGoodsOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[MLGoodsOrderTableViewCell identifier]];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        MLOrder *order = _orders[indexPath.section];
//        MLGoods *goods = order.multiGoods[indexPath.row];
//        cell.goods = goods;
        return cell;

        
	} else if (class == [MLAfterSalesInfoTableViewCell class]) {
		MLAfterSalesInfoTableViewCell *infoCell = (MLAfterSalesInfoTableViewCell *)cell;
		infoCell.delegate = self;
		infoCell.type = _type;
		infoCell.reason = _reason;
		infoCell.uploadedImages = [NSArray arrayWithArray:_uploadedImages];
	}
    else if(class == [MLAddressTableViewCell class]&&self.address) {
        MLAddressTableViewCell *addressCell = (MLAddressTableViewCell *)cell;
        addressCell.address = _address;
        addressCell.indexPath = indexPath;
        addressCell.editOrderMode = YES;
        [addressCell setAfterSaleCellState:_type];
        addressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	if (class == [MLAddAddressTableViewCell class]) {
        MLAddressesViewController *controller = [[MLAddressesViewController alloc] initWithNibName:nil bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        controller.selectMode = YES;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
//		MLEditAddressViewController *editAddressViewController = [[MLEditAddressViewController alloc] initWithNibName:nil bundle:nil];
//		[self.navigationController pushViewController:editAddressViewController animated:YES];
	}
}


#pragma mark - 选择邮寄地址回调
- (void)selectedAddress:(MLAddress *)address
{
    self.address = address;
    [self.tableView reloadData];
}
@end
