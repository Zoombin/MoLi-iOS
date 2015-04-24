//
//  MLAfterSaleServiceDetailViewController.m
//  MoLi
//
//  Created by LLToo on 15/4/11.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLAfterSaleServiceDetailViewController.h"
#import "MLAfterSalesGoods.h"
#import "MLAfterSaleGoodsDetailCell.h"
#import "MLAfterSalePromblemDescCell.h"
#import "MLAfterSaleAddrCell.h"
#import "MLCache.h"

@interface MLAfterSaleServiceDetailViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (readwrite) UITableView *tableView;
@property (nonatomic,strong) MLResponse *afterGoodsResponse;

@end

@implementation MLAfterSaleServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    NSString *strTitle = [NSString stringWithFormat:@"售后详情 %@",(self.afterGoods.type==MLAfterSalesTypeReturn)?@"退货":@"换货"];
    self.title = NSLocalizedString(strTitle, nil);
    [self setLeftBarButtonItemAsBackArrowButton];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            self.afterGoodsResponse = response;
            [self updateAllData];
        }
    }];
}

// 刷新页面
- (void)updateAllData
{    
    [self.tableView reloadData];
}


#pragma mark - UITableVewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return [MLAfterSaleGoodsDetailCell height:self.afterGoods.type];
    }
    else if(indexPath.section==1) {
        NSString *bremark = [[self.afterGoodsResponse.data objectForKey:@"service"] objectForKey:@"bremark"];
        return [MLCache isNullObject:bremark]?[MLAfterSalePromblemDescCell height:NO]:[MLAfterSalePromblemDescCell height:YES];
    }
    else {
        return [MLAfterSaleAddrCell height];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.afterGoods.type == MLAfterSalesTypeReturn)
        return 2;
    else
        return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0) {
        MLAfterSaleGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
        if (!cell) {
            cell = [[MLAfterSaleGoodsDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[MLAfterSaleGoodsDetailCell identifier] type:self.afterGoods.type];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.afterSaleGoodsDetailDict = self.afterGoodsResponse.data;
        return cell;
    }
    else if(indexPath.section==1) {
        MLAfterSalePromblemDescCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
        if (!cell) {
            cell = [[MLAfterSalePromblemDescCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[MLAfterSalePromblemDescCell identifier]];
             NSString *bremark = [[self.afterGoodsResponse.data objectForKey:@"service"] objectForKey:@"bremark"];
            BOOL isBreMark = [MLCache isNullObject:bremark]? NO : YES;
            cell.isBremark = isBreMark;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.afterSaleGoodsDetailDict = self.afterGoodsResponse.data;
        return cell;
    }
    else {
        MLAfterSaleAddrCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
        if (!cell) {
            cell = [[MLAfterSaleAddrCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[MLAfterSaleAddrCell identifier]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.afterSaleGoodsDetailDict = self.afterGoodsResponse.data;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
