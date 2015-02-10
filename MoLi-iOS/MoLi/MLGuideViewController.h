//
//  MLGuideViewController.h
//  MoLi
//
//  Created by zhangbin on 1/16/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLGuideViewControllerDelegate <NSObject>

- (void)endGuide;

@end

@interface MLGuideViewController : UIViewController

@property (nonatomic, weak) id <MLGuideViewControllerDelegate> delegate;

@end
