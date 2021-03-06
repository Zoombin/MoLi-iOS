//
//  MLNoDataView.h
//  MoLi
//
//  Created by zhangbin on 2/3/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLNoDataViewDelegate <NSObject>
- (void)noDataViewReloadData;
@end

/// 没有更多信息view.
@interface MLNoDataView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) id<MLNoDataViewDelegate> delegate;

@end
