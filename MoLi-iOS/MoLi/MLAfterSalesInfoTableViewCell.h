//
//  MLAfterSalesInfoTableViewCell.h
//  MoLi
//
//  Created by zhangbin on 2/2/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLAfterSalesGoods.h"

@protocol MLAfterSalesInfoTableViewCellDelegate <NSObject>

- (void)didSelectAfterSalesType:(MLAfterSalesType)type;
- (void)didEndEditing:(NSString *)text;
- (void)willAddPhoto;
- (void)willDeletePhotoAtIndex:(NSInteger)index;

@end

@interface MLAfterSalesInfoTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MLAfterSalesInfoTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSArray *uploadedImages;
@property (nonatomic, assign) MLAfterSalesType type;
@property (nonatomic, strong) NSString *reason;

@end
