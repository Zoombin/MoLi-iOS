//
//  UIViewController+ImagePicker.h
//  dushuhu
//
//  Created by zhangbin on 8/2/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ImagePicker)

- (UIImagePickerController *)imagePickerForActionSheet:(UIActionSheet *)actionSheet withButtonIndex:(NSInteger)buttonIndex;

@end
