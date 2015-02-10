//
//  ZBHorizontalScrollTableViewCell.h
//  dushuhu
//
//  Created by zhangbin on 3/26/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZBHorizontalScrollTableViewCellDelegate;
@interface ZBHorizontalScrollTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ZBHorizontalScrollTableViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL autoScrollEnabled;

- (void)reloadData;

@end


@protocol ZBHorizontalScrollTableViewCellDelegate <NSObject>

- (NSInteger)numberOfColumnsForCell:(ZBHorizontalScrollTableViewCell *)cell inSection:(NSInteger)section;
- (CGFloat)heightForCell:(ZBHorizontalScrollTableViewCell *)cell inSection:(NSInteger)section;
- (UIView *)horizontalScrollTableViewCell:(ZBHorizontalScrollTableViewCell *)cell contentViewForColumnAtIndex:(NSInteger)index inSection:(NSInteger)section;

@end
