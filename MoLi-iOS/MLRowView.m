//
//  MLRowView.m
//  MoLi
//
//  Created by imooly-mac on 15/4/9.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLRowView.h"

@implementation MLRowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 0.4;
        _rowbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_rowbtn setBackgroundColor:[UIColor clearColor]];
        [_rowbtn addTarget:self action:@selector(rowbtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rowbtn];
        
        _rowname = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 160, 20)];
        [_rowname setFont:[UIFont systemFontOfSize:15]];
        [_rowname setTextColor:[UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:1]];
        [_rowname setBackgroundColor:[UIColor clearColor]];
        [_rowbtn addSubview:_rowname];
        
        _rowimageview = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-25-15, 17, 33, 14)];
//        [_rowimageview setBackgroundColor:[UIColor redColor]];
        [_rowbtn addSubview:_rowimageview];
        

    }
    return self;
}

-(void)rowbtnClick{
    if (_delegate && [_delegate respondsToSelector:@selector(selectRowView:)]) {
        [_delegate selectRowView:self];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
