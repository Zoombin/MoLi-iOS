//
//  ZBBottomIndexScrollView.h
//  MoLi
//
//  Created by zhangbin on 12/27/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZBBottomIndexViewDelegate <NSObject>

- (void)bottomIndexViewSelected:(NSInteger)selectedIndex;

@end

@interface ZBBottomIndexView : UIView

@property (nonatomic, weak) id <ZBBottomIndexViewDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *highlights;
@property (nonatomic, strong) NSArray *normals;
@property (nonatomic, strong) UIColor *indexColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleColorSelected;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL hiddenIndexView;
@property (nonatomic, strong) UIImage *images;
@property (nonatomic, strong) UIImageView *imageviews;

- (void)setSelectedIndex:(NSInteger)selectedIndex;
- (void)swipe:(UISwipeGestureRecognizer *)swipe;
- (UISwipeGestureRecognizer *)leftSwipeGestureRecognizer;
- (UISwipeGestureRecognizer *)rightSwipeGestureRecognizer;

@end
