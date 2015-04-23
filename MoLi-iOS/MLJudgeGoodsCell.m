//
//  MLJudgeGoodsCellTableViewCell.m
//  MoLi
//
//  Created by yc on 15-4-22.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLJudgeGoodsCell.h"

@implementation MLJudgeGoodsCell

- (void)awakeFromNib {
    // Initialization code
    _iconImageView.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    _iconImageView.layer.borderWidth = 0.5;
    
    _commentTextView.backgroundColor = [UIColor backgroundColor];
    _commentTextView.delegate = self;
    [_commentTextView.layer setCornerRadius:4.0];
    [_commentTextView.layer setMasksToBounds:YES];
    
    [self addDeleteIcons];
}

// 为图片添加删除图标
- (void)addDeleteIcons
{
    UIImage *deleteImage = [UIImage imageNamed:@"DeleteUploadedImage"];
    self.imgviewDel1 = [[UIImageView alloc] initWithImage:deleteImage];
    [self.imgviewDel1 setFrame:CGRectMake(0, 0, 15, 15)];
    self.imgviewDel1.center = CGPointMake(CGRectGetMaxX(_photo1.bounds), 0);
    [_photo1 addSubview:self.imgviewDel1];
    
    deleteImage = [UIImage imageNamed:@"DeleteUploadedImage"];
    self.imgviewDel2 = [[UIImageView alloc] initWithImage:deleteImage];
    [self.imgviewDel2 setFrame:CGRectMake(0, 0, 15, 15)];
    self.imgviewDel2.center = CGPointMake(CGRectGetMaxX(_photo2.bounds), 0);
    [_photo2 addSubview:self.imgviewDel2];
    
    deleteImage = [UIImage imageNamed:@"DeleteUploadedImage"];
    self.imgviewDel3 = [[UIImageView alloc] initWithImage:deleteImage];
    [self.imgviewDel3 setFrame:CGRectMake(0, 0, 15, 15)];
    self.imgviewDel3.center = CGPointMake(CGRectGetMaxX(_photo3.bounds), 0);
    [_photo3 addSubview:self.imgviewDel3];
    
    [self refreshButton:nil];
}


- (IBAction)starButtonClicked:(id)sender {
    NSArray *btns = @[_star1, _star2, _star3, _star4, _star5];
    NSString *star = [NSString stringWithFormat:@"%d", [sender tag]];
    for (int i = 0; i < [btns count]; i++) {
        UIButton *btn = btns[i];
        if (i < [sender tag]) {
             btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(starChanged:index:)]) {
        [self.delegate starChanged:star index:self.tag];
    }
}

- (void)setStar:(NSString *)star {
    NSArray *btns = @[_star1, _star2, _star3, _star4, _star5];
    for (int i = 0; i < [btns count]; i++) {
        UIButton *btn = btns[i];
        if (i < [star integerValue]) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

- (void)setContent:(NSString *)content {
    _commentTextView.text = content;
    _placeholderLabel.hidden = NO;
    _wordsCount.text = [NSString stringWithFormat:@"%d", 140 - [content length]];
    if ([content length] > 0) {
        _placeholderLabel.hidden = YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] == 0) {
        _placeholderLabel.hidden = NO;
    }
    _wordsCount.text = [NSString stringWithFormat:@"%d", 140 - [textView.text length]];
    if ([_wordsCount.text length] > 140) {
        _wordsCount.textColor = [UIColor orangeColor];
    } else {
        _wordsCount.textColor = [UIColor lightGrayColor];
    }
    _placeholderLabel.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(contentChanged:index:)]) {
        [self.delegate contentChanged:_commentTextView.text index:self.tag];
    }
}

- (IBAction)photoButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(takePhoto:currentButton:)]) {
        [self.delegate takePhoto:self.tag currentButton:[sender tag]];
    }
}

- (void)refreshButton:(NSArray *)imagePaths {
    self.imgviewDel1.hidden = NO;
    self.imgviewDel2.hidden = NO;
    self.imgviewDel3.hidden = NO;

    if ([imagePaths count] == 0) {
        [_photo1 setBackgroundImage:[UIImage imageNamed:@"afterSaleAdd"] forState:UIControlStateNormal];
        self.imgviewDel1.hidden = YES;
        _photo2.hidden = YES;
        _photo3.hidden = YES;
    }
    if ([imagePaths count] == 1) {
        [_photo2 setBackgroundImage:[UIImage imageNamed:@"afterSaleAdd"] forState:UIControlStateNormal];
        self.imgviewDel2.hidden = YES;
        _photo2.hidden = NO;
        _photo3.hidden = YES;
    }
    if ([imagePaths count] == 2) {
        [_photo3 setBackgroundImage:[UIImage imageNamed:@"afterSaleAdd"] forState:UIControlStateNormal];
        self.imgviewDel3.hidden = YES;
        _photo2.hidden = NO;
        _photo3.hidden = NO;
    }
    if ([imagePaths count] == 3) {
        _photo2.hidden = NO;
        _photo3.hidden = NO;
    }
    if ([imagePaths count] > 0) {
        for (int i = 0; i < [imagePaths count]; i++) {
            NSDictionary *info = imagePaths[i];
            if (i == 0) {
                [_photo1 setBackgroundImage:info[@"img"] forState:UIControlStateNormal];
            }
            if (i == 1) {
                [_photo2 setBackgroundImage:info[@"img"] forState:UIControlStateNormal];
            }
            if (i == 2) {
                [_photo3 setBackgroundImage:info[@"img"] forState:UIControlStateNormal];
            }
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
