//
//  MLCommonCollectionViewCell.h
//  MoLi
//
//  Created by zhangbin on 1/9/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLCommonCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSAttributedString *attributedText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end
