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
    
    [self fetchAfterGoodsDetailInfo];
    
}


#pragma mark - 私有方法
// 获取数据
- (void)fetchAfterGoodsDetailInfo
{
    [self displayHUD:@"加载中..."];
    [[MLAPIClient shared] fetchAfterSalesDetailInfo:self.afterGoods withBlock:^(MLResponse *response) {
        [self displayResponseMessage:response];
        if (response.success) {
            NSLog(@".....%@",response.data);
            [self.tableView reloadData];
        }
    }];
}


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


#pragma mark - UITableVewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.afterGoods.type == MLAfterSalesTypeReturn)
        return 2;
    else
        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
