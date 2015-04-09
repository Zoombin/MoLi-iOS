//
//  MLRowView.h
//  MoLi
//
//  Created by imooly-mac on 15/4/9.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLRowViewDelegate;

@interface MLRowView : UIView

@property (nonatomic,strong)UILabel *rowname;
@property (nonatomic, strong)UIButton *rowbtn;
@property (nonatomic, strong)UIImageView *rowimageview;
@property (nonatomic, weak) id <MLRowViewDelegate> delegate;
@property BOOL isSelect;
@end

@protocol MLRowViewDelegate <NSObject>

-(void)selectRowView:(MLRowView*)rowview;

@end