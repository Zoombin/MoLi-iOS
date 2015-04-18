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

/// 评价页面.
@interface MLJudgeViewController : UIViewController<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) MLOrder *order;
@property (nonatomic, weak) IBOutlet UIView *footView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextView *commentTextView;
@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, weak) IBOutlet UIButton *photo1;
@property (nonatomic, weak) IBOutlet UIButton *photo2;
@property (nonatomic, weak) IBOutlet UIButton *photo3;
@property (nonatomic, weak) IBOutlet UIButton *star1;
@property (nonatomic, weak) IBOutlet UIButton *star2;
@property (nonatomic, weak) IBOutlet UIButton *star3;
@property (nonatomic, weak) IBOutlet UIButton *star4;
@property (nonatomic, weak) IBOutlet UIButton *star5;
- (IBAction)starButtonClicked:(id)sender;
- (IBAction)sendComment:(id)sender;
- (IBAction)selectPhoto:(id)sender;
@end
