//
//  MLFilterTableViewCell.m
//  MoLi
//
//  Created by imooly-mac on 15/4/7.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLFilterTableViewCell.h"
#import "UIButton+DashLine.h"

@implementation MLFilterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//+ (CGFloat)height {
//    return 250;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
//        [self setBackgroundColor:[UIColor greenColor]];
//        _specButtons = [NSMutableArray array];
    }
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 50, 30)];
//    [btn setBackgroundColor:[UIColor redColor]];
//    [self addSubview:btn];
    
    return self;
}

//-(void)creatBtutton:(NSMutableArray*)array{
//    for (UIButton *button in _specButtons) {
//        
//        [button removeFromSuperview];
//        
//    }
//     [_specButtons removeAllObjects];
//    
//    NSInteger numberPerLine = 3;
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(19, 10, 19, 10);
//    CGFloat buttonWidth = 73;
//    if ([UIScreen mainScreen].bounds.size.width > 320) {
//        buttonWidth = 102;
//    }
//    CGRect rect = CGRectMake(edgeInsets.left, edgeInsets.top-10, buttonWidth, 32);
//    for	(int i = 0; i < array.count;) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:array[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
//        button.titleLabel.adjustsFontSizeToFitWidth = YES;
////        		button.layer.borderWidth = 0.5;
////        		button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        button.frame = rect;
//        [button addTarget:self action:@selector(selectSpecButton:) forControlEvents:UIControlEventTouchUpInside];
//        i++;
//        rect.origin.x += rect.size.width + edgeInsets.left;
//        if (i % numberPerLine == 0) {
//            rect.origin.x = edgeInsets.left;
//            rect.origin.y += rect.size.height + edgeInsets.bottom;
//        }
//        [button drawDashedBorder];
//        [self.contentView addSubview:button];
//        [_specButtons addObject:button];
//    }
//
//
//}


//-(void)selectSpecButton:(UIButton*)btn{
//
//
//}
//
//
//- (void)prepareForReuse {
//    [super prepareForReuse];
//    for (UIButton *buttonss in _specButtons) {
//        [buttonss removeFromSuperview];
//    }
//    [_specButtons removeAllObjects];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
