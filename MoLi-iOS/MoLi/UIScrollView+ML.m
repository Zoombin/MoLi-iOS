//
//  UIScrollView+ML.m
//  MoLi
//
//  Created by LLToo on 15/4/15.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "UIScrollView+ML.h"

@implementation UIScrollView(ML)

- (void)addMoLiHeadView
{
    UIImageView *collectionHeadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_bg"]];
    collectionHeadView.center = CGPointMake(self.bounds.size.width/2.0, -collectionHeadView.frame.size.height/2.0);
    [self addSubview:collectionHeadView];
}

@end
