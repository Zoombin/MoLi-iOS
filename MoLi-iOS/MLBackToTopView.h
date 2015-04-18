//
//  MLBackToTopView.h
//  MoLi
//
//  Created by zhangbin on 4/11/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLBackToTopViewDelegate <NSObject>

- (void)willBackToTop;

@end

/// 工具View.
@interface MLBackToTopView : UIView

@property (nonatomic, weak) id <MLBackToTopViewDelegate> delegate;

+ (CGSize)size;

@end
