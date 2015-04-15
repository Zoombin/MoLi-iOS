//
//  MLViewHistoryViewController.m
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLViewHistoryViewController.h"
#import "Header.h"
#import "MLNoDataView.h"
#import "MLCache.h"
#import "MLFavoritesGoodsTableViewCell.h"
#import "MLGoodsDetailsViewController.h"

@interface MLViewHistoryViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (readwrite) MLNoDataView *noDataView;
@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *arrayMoliGoods;

@end

@implementation MLViewHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"我的足迹", nil);
	
    if (![MLCache hasDataFromMoliGoodsCache]) {
        [self showNoResultView];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"清空", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        self.arrayMoliGoods = [[NSArray alloc] initWithArray:[MLCache getCacheMoliGoods]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showNoResultView {
    self.navigationItem.rightBarButtonItem = nil;
    if (!_noDataView) {
        _noDataView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
        _noDataView.imageView.image = [UIImage imageNamed:@"NoViewHistory"];
        _noDataView.label.text = @"您还没有留下足迹";
        [self.view addSubview:_noDataView];
    }
}

- (void)clear {
    [MLCache clearAllMoliGoodsData];
    _tableView.hidden = YES;
    [self showNoResultView];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayMoliGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MLFavoritesGoodsTableViewCell identifier]];
    if (!cell) {
        cell = [[MLFavoritesGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MLFavoritesGoodsTableViewCell identifier]];
    }
    MLGoods *goods = self.arrayMoliGoods[self.arrayMoliGoods.count - indexPath.row - 1];
    [(MLFavoritesGoodsTableViewCell*)cell updateValue:goods];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MLGoods *goods = self.arrayMoliGoods[indexPath.row];
    MLGoodsDetailsViewController *goodsDetailsViewController = [[MLGoodsDetailsViewController alloc] initWithNibName:nil bundle:nil];
    goodsDetailsViewController.goods = goods;
    [self.navigationController pushViewController:goodsDetailsViewController animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
