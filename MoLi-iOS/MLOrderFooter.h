//
//  MLOrderFooter.h
//  MoLi
//
//  Created by 颜超 on 15/4/13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 订单的footer.
@interface MLOrderFooter : UIView

@property (nonatomic, weak) IBOutlet UIImageView *dashLine1;
@property (nonatomic, weak) IBOutlet UIImageView *dashLine2;
@property (nonatomic, weak) IBOutlet UILabel *orderNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *ticketMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel *createTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *finshTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *sendTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *sureTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@end
