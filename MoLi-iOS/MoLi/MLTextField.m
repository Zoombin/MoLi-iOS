//
//  MLTextField.m
//  MoLi
//
//  Created by 颜超 on 15/1/31.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLTextField.h"
#import "Header.h"

@implementation MLTextField

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		self.textColor = [UIColor fontGrayColor];
		self.font = [UIFont systemFontOfSize:14];
	}
	return self;
}

//控制 placeHolder 的位置，左右缩 20
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 20 , 0 );
}

// 控制文本的位置，左右缩 20
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 20 , 0 );
}

@end
