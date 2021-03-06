//
//  MLGoodsIntroduceCollectionViewCell.m
//  MoLi
//
//  Created by zhangbin on 1/10/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLGoodsIntroduceCollectionViewCell.h"
#import "Header.h"

@implementation MLGoodsIntroduceCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageViews = [[UIImageView alloc] initWithFrame:CGRectMake(17, self.frame.size.height-20+15, 20, 20)];
        [_imageViews setBackgroundColor:[UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1]];
        [self addSubview:_imageViews];
        _imageViews.hidden = YES;
    }
    return self;
}
+ (CGFloat)heightPerIntroduceElementLine {
	return 19;
}

@end
