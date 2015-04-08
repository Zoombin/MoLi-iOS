//
//  HeadView.h
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeadViewDelegate; 

@interface HeadView : UIView{
    id<HeadViewDelegate> delegate;
    NSInteger section;
    UIButton* backBtn;
    BOOL open;
    UIImageView *imageView;
}
@property(nonatomic, assign) id<HeadViewDelegate> delegate;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) BOOL open;
@property(nonatomic, retain) UIButton* backBtn;
@property(nonatomic, strong) UILabel *topLine;
@property(nonatomic, strong) UILabel *buttomLine;
@property(nonatomic, strong) UIImageView *imageView;;

@property (nonatomic,assign)NSInteger boardLine;
//名称
@property(nonatomic, strong) UILabel *nameLabel;

//记录选择的条件
@property(nonatomic, strong) UILabel *chooseNoteLabel;

@end

@protocol HeadViewDelegate <NSObject>
-(void)selectedWith:(HeadView *)view;
@end
