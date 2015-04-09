//
//  HeadView.m
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView
@synthesize delegate = _delegate;
@synthesize section,open,backBtn,imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        open = NO;
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 320-55, 47.5);
        [btn addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];
//        btn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
//        btn.backgroundColor = [UIColor redColor];
//        [btn setImage:[UIImage imageNamed:@"ic_shouye_xiala"] forState:UIControlStateNormal];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(btn.frame)-30, 0, 30, 48)];
        [imageView setImage:[UIImage imageNamed:@"lightarricon"]];
//        [imageView setBackgroundColor:[UIColor greenColor]];
        imageView.contentMode = UIViewContentModeCenter;
        [btn addSubview:imageView];
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 280, 0, 0);
        [self addSubview:btn];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 150, 29.5)];
        [self.nameLabel setFont:[UIFont systemFontOfSize:15]];
        [btn addSubview:self.nameLabel];
        CGFloat minX = CGRectGetMinX(imageView.frame);
        self.chooseNoteLabel = [[UILabel alloc]initWithFrame:CGRectMake(minX-120, 10, 120, 29.5)];
        [self.chooseNoteLabel setTextAlignment:NSTextAlignmentRight];
        self.chooseNoteLabel.font = [UIFont systemFontOfSize:14.0];
        [self.chooseNoteLabel setTextColor:[UIColor themeColor]];
//        self.chooseNoteLabel.backgroundColor = [UIColor redColor];
//        self.chooseNoteLabel.backgroundColor = [UIColor yellowColor];
        [btn addSubview:self.chooseNoteLabel];
        
        self.topLine = [[UILabel alloc]initWithFrame:CGRectZero];
        [btn addSubview:self.topLine];
        
        self.buttomLine = [[UILabel alloc]initWithFrame:CGRectZero];
        [btn addSubview:self.buttomLine];
        
        self.backBtn = btn;
    }
    return self;
}

-(void)setBoardLine:(NSInteger)boardLine{
    _boardLine = boardLine;
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, _boardLine);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGFloat lengths[] = {10,2};
    CGContextSetLineDash(context, 0, lengths,_boardLine);
    CGContextMoveToPoint(context, 0.0, 48.0);
    CGContextAddLineToPoint(context, 320.0-55,48.0);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}

-(void)doSelected{
    if (!self.open) {
        [imageView setImage:[UIImage imageNamed:@"xuanzhuang"]];
    }else{
        [imageView setImage:[UIImage imageNamed:@"lightarricon"]];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
     	[_delegate selectedWith:self];
    }
}
@end
