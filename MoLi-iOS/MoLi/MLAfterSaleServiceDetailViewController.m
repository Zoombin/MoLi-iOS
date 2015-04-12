//
//  MLAfterSaleServiceDetailViewController.m
//  MoLi
//
//  Created by LLToo on 15/4/11.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLAfterSaleServiceDetailViewController.h"
#import "MLAfterSalesGoods.h"

@interface MLAfterSaleServiceDetailViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (readwrite) UITableView *tableView;

@end

@implementation MLAfterSaleServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    NSString *strTitle = [NSString stringWithFormat:@"售后详情 %@",(self.afterGoods.type==MLAfterSalesTypeReturn)?@"退货":@"换货"];
    self.title = NSLocalizedString(strTitle, nil);
    [self setLeftBarButtonItemAsBackArrowButton];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}


#pragma mark - 私有方法
// 商品介绍cell
- (UITableViewCell *)goodsDescCell
{
    return nil;
}

// 问题描述cell
- (UITableViewCell *)problemDescCell
{
    return nil;
}

// 收货地址cell
- (UITableViewCell *)addrDescCell
{
    return nil;
}



@end
