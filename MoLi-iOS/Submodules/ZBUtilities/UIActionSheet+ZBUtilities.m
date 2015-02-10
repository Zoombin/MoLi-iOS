//
//  UIActionSheet+ZBUtilities.m
//  dushuhu
//
//  Created by zhangbin on 8/2/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "UIActionSheet+ZBUtilities.h"

@implementation UIActionSheet (DSH)

+ (instancetype)imagePickerActionSheet
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil), NSLocalizedString(@"从相册选取", nil), nil];
	return actionSheet;
}

@end
