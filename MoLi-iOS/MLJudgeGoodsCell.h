//
//  MLJudgeGoodsCellTableViewCell.h
//  MoLi
//
//  Created by yc on 15-4-22.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 订单评价的cell.

@protocol MLJudgeGoodsCellDelegate <NSObject>
- (void)starChanged:(NSString *)stars
              index:(NSInteger)index;

- (void)contentChanged:(NSString *)content
                 index:(NSInteger)index;

- (void)takePhoto:(NSInteger)index
    currentButton:(NSInteger)tag;
@end

@interface MLJudgeGoodsCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *goodsNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *numLabel;
@property (nonatomic, weak) IBOutlet UITextView *commentTextView;
@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, weak) IBOutlet UIButton *photo1;
@property (nonatomic, weak) IBOutlet UIButton *photo2;
@property (nonatomic, weak) IBOutlet UIButton *photo3;
@property (nonatomic, weak) IBOutlet UIButton *star1;
@property (nonatomic, weak) IBOutlet UIButton *star2;
@property (nonatomic, weak) IBOutlet UIButton *star3;
@property (nonatomic, weak) IBOutlet UIButton *star4;
@property (nonatomic, weak) IBOutlet UIButton *star5;
@property (nonatomic, strong) UIImageView *imgviewDel1;
@property (nonatomic, strong) UIImageView *imgviewDel2;
@property (nonatomic, strong) UIImageView *imgviewDel3;

@property (nonatomic, weak) id<MLJudgeGoodsCellDelegate> delegate;

- (IBAction)starButtonClicked:(id)sender;
- (IBAction)photoButtonClicked:(id)sender;
- (void)setStar:(NSString *)star;
- (void)refreshButton:(NSArray *)imagePaths;
- (void)setContent:(NSString *)content;
@end
