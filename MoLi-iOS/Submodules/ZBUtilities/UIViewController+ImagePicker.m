//
//  UIViewController+ImagePicker.m
//  dushuhu
//
//  Created by zhangbin on 8/2/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "UIViewController+ImagePicker.h"

@interface UIViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate>
@end

@implementation UIViewController (ImagePicker)

- (UIImagePickerController *)imagePickerForActionSheet:(UIActionSheet *)actionSheet withButtonIndex:(NSInteger)buttonIndex;
{
	if (buttonIndex == actionSheet.cancelButtonIndex || buttonIndex == actionSheet.destructiveButtonIndex) {
		return nil;
	}
	
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	if (buttonIndex == 0) {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		}
	}
	return imagePickerController;
}

@end
