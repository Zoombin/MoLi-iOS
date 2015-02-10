//
//  MLProfileViewController.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLProfileViewController.h"
#import "Header.h"
#import "MLUser.h"
#import "MLChangeNicknameViewController.h"

@interface MLProfileViewController () <
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (readwrite) UITableView *tableView;

@end

@implementation MLProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"个人信息", nil);
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
//		UIImage *image = info[UIImagePickerControllerOriginalImage];
//		NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
//		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//		dateFormatter.dateFormat = @"yyyyMMddHHmmss";
//		NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//		NSString *filename = [NSString stringWithFormat:@"%@_%@%@", [DSHAPIClient shared].userID, dateString, @".jpg"];
//		[self displayHUD:NSLocalizedString(@"上传中...", nil)];//TODO: localizing
	}];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	MLUser *me = [MLUser unarchive];
	if (indexPath.row == 0) {
        //TO DO:此处缺placeholder
		[cell.imageView setImageWithURL:[NSURL URLWithString:me.avatarURLString] placeholderImage:[UIImage imageNamed:@"Avatar"]];
	} else if (indexPath.row == 1) {
		cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"昵称", nil), me.nickname ?: @""];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row == 0) {
		UIActionSheet *actionSheet = [UIActionSheet imagePickerActionSheet];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	} else {
		MLChangeNicknameViewController *changeNicknameViewController = [[MLChangeNicknameViewController alloc] initWithNibName:nil bundle:nil];
		changeNicknameViewController.hidesBottomBarWhenPushed = YES;
        [changeNicknameViewController setLeftBarButtonItemAsBackArrowButton];
		[self.navigationController pushViewController:changeNicknameViewController animated:YES];
		return;
	}
}

@end
