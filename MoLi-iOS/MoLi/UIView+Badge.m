//
//  UIView+Badge.m
//  MLTBadgedView
//
//  Created by Robert Rasmussen on 10/2/10.
//  Copyright 2010 Moonlight Tower. All rights reserved.
//

#import "UIView+Badge.h"

static int MLT_BADGE_TAG = 6546;

@implementation MLTBadgeView
@synthesize placement, badgeValue, font, badgeColor, textColor, outlineColor, outlineWidth, minimumDiameter, displayWhenZero;

- (void)dealloc {
    self.font = nil;
    self.badgeColor = nil;
    self.textColor = nil;
    self.outlineColor = nil;
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.font = [UIFont boldSystemFontOfSize:13.0];
        self.badgeColor = [UIColor redColor];
        self.textColor = [UIColor whiteColor];
        self.outlineColor = [UIColor whiteColor];
        self.outlineWidth = 2.0;
        self.backgroundColor = [UIColor clearColor];
        self.minimumDiameter = 20.0;
        self.placement = kBadgePlacementUpperRight;
        self.opaque = YES;
        self.displayWhenZero = NO;
    }
    return self;
}

- (void)setBadgeValue:(NSInteger)value {
    if(value != 0 || self.displayWhenZero) {
        CGSize numberSize = [[NSString stringWithFormat:@"%d", value] sizeWithAttributes:@{NSFontAttributeName : self.font}];
        float diameterForNumber = numberSize.width > numberSize.height ? numberSize.width : numberSize.height;
        float diameter = diameterForNumber + 6 + (self.outlineWidth * 2);
        if(diameter < self.minimumDiameter) {
            diameter = self.minimumDiameter;
        }
        
        //We know the size of the badge circle. If no explicit placement for the badge has been set, we'll
        //see if it works on the right side first.
        CGRect superviewFrame = self.superview.frame;
        if(self.placement == kBadgePlacementUpperBest) {
            CGPoint rightMostInWindow = [self.superview convertPoint:CGPointMake(superviewFrame.origin.x + superviewFrame.size.width + (diameter / 2.0), -(diameter / 2.0)) fromView:nil];
            if(rightMostInWindow.x > [[UIScreen mainScreen] applicationFrame].size.width) {
                self.placement = kBadgePlacementUpperLeft;
            } else {
                self.placement = kBadgePlacementUpperRight;
            }
        }
        self.bounds = CGRectMake(0, 0, diameter, numberSize.height + 2);
        self.center = (self.placement == kBadgePlacementUpperLeft) ? CGPointMake(0, 0) : CGPointMake(superviewFrame.size.width - 30, 0);
    } else {
        self.frame = CGRectZero;
    }
    badgeValue = value;
    [self setNeedsDisplay];
}

- (void)setMinimumDiameter:(float)f {
    minimumDiameter = f;
    self.bounds = CGRectMake(0, 0, f, f);
}

- (void)drawRect:(CGRect)rect {
    if(self.badgeValue != 0 || self.displayWhenZero) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.outlineColor set];
        [self draw:context width:rect.size.width height:rect.size.height];
        [self.badgeColor set];
        // 绘制椭圆
        [self draw:context width:rect.size.width height:rect.size.height];
        [self.textColor set];
        CGSize numberSize = [[NSString stringWithFormat:@"%d", self.badgeValue] sizeWithAttributes:@{NSFontAttributeName : self.font}];
        [[NSString stringWithFormat:@"%d", self.badgeValue] drawInRect:CGRectMake(self.outlineWidth + 3, (rect.size.height / 2.0) - (numberSize.height / 2.0), rect.size.width - (self.outlineWidth * 2) - 6, numberSize.height) withFont:self.font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    }
}

- (void)draw:(CGContextRef)context width:(int)width height:(int)height {
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius = height / 2;
    // 移动到初始点
    CGContextMoveToPoint(context, radius, 0);
    
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius, 0);
    CGContextAddArc(context, width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, width, height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
    
    // 闭合路径
    CGContextClosePath(context);
    // 填充半透明黑色
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextDrawPath(context, kCGPathFill);
}

//sizeWithAttributes:@{NSFontAttributeName : self.font

@end


@implementation UIView(Badged)

-(MLTBadgeView *)badge {
    UIView *existingView = [self viewWithTag:MLT_BADGE_TAG];
    if(existingView) {
        if(![existingView isKindOfClass:[MLTBadgeView class]]) {
            return nil;
        } else {
            return (MLTBadgeView *)existingView;
        }
    }
    MLTBadgeView *badgeView = [[MLTBadgeView alloc]initWithFrame:CGRectZero];
    badgeView.tag = MLT_BADGE_TAG;
    [self addSubview:badgeView];
    return badgeView;
}

@end
