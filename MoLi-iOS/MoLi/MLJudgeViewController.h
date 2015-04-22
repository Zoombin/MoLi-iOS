//
//  MLJudgeViewController.h
//  MoLi
//
//  Created by 颜超 on 15/4/16.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLOrder.h"
#import "UIActionSheet+ZBUtilities.h"
#import "MLJudgeGoodsCell.h"

/// 评价页面.
@interface MLJudgeViewController : UIViewController<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MLJudgeGoodsCellDelegate>

@property (nonatomic, weak) MLOrder *order;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
- (IBAction)sendComment:(id)sender;
@end
