//
//  MLOrderStoreCell.h
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLOrderStoreCellDelegate <NSObject>
- (void)showStoreDetail;
- (void)phoneButtonClick;
@end

@interface MLOrderStoreCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *storeNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *detailButton;
@property (nonatomic, weak) IBOutlet UIButton *phoneButton;
@property (nonatomic, weak) IBOutlet UILabel *orderStateLabel;
@property (nonatomic, weak) id<MLOrderStoreCellDelegate> delegate;
- (IBAction)storeDetailButtonClicked:(id)sender;
- (IBAction)phoneButtonClicked:(id)sender;
@end
