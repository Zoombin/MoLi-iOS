//
//  MLOrderAddressCell.h
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLOrderAddressCellDelegate <NSObject>
- (void)showLogisticInfo;

@end

@interface MLOrderAddressCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *postCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *logisticLabel;
@property (nonatomic, weak) IBOutlet UILabel *logisticTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *dashLine;
@property (nonatomic, weak) id<MLOrderAddressCellDelegate> delegate;
- (IBAction)logisticButtonClicked:(id)sender;
@end
