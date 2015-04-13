//
//  MLOrderDetailViewController.m
//  MoLi
//
//  Created by yc on 15-4-13.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLOrderDetailViewController.h"
#import "MLAPIClient.h"
#import "MLOrderAddress.h"
#import "MLGoods.h"
#import "MLLogistic.h"
#import "MLOrderStatusInfo.h"
#import "MLOrderStore.h"
#import "MLStoreDetailsViewController.h"
#import "MLLogisticViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLAskForAfterSalesViewController.h"
#import "MLOrderFooter.h"
#import "MLAfterSalesGoods.h"

@interface MLOrderDetailViewController ()

@end

@implementation MLOrderDetailViewController {
    NSArray *goodsArray;
    MLOrderAddress *address;
    MLLogistic *logistic;
    MLOrderStore *orderStore;
    MLOrderStatusInfo *statusInfo;
    MLOrderFooter *footerView;
    UITableView *infoTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"订单详情", nil);
    infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    infoTableView.dataSource = self;
    infoTableView.delegate = self;
    infoTableView.backgroundColor = [UIColor clearColor];
    infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:infoTableView];
    
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MLOrderFooter" owner:nil options:nil];
     footerView = [nibs lastObject];
    [infoTableView setTableFooterView:footerView];

    
    self.view.backgroundColor = [UIColor backgroundColor];
    [self setLeftBarButtonItemAsBackArrowButton];
    [self loadOrderDetail];
    // Do any additional setup after loading the view.
}

- (void)loadOrderDetail {
    [self displayHUD:@"加载中..."];
    [[MLAPIClient shared] orderProfile:_order.ID withBlock:^(NSDictionary *attributes, MLResponse *response) {
        [self displayResponseMessage:response];
        if (response.success) {
            NSLog(@"%@", attributes);
            [self initData:attributes];
        }
    }];
}

- (void)initData:(NSDictionary *)result {
    address = [[MLOrderAddress alloc] initWithAttributes:result[@"address"]];
    goodsArray = [MLGoods createGoodsWithArray:result[@"goods"]];
    logistic = [[MLLogistic alloc] initWithAttributes:result[@"logistic"]];
    statusInfo = [[MLOrderStatusInfo alloc] initWithAttributes:result[@"status"]];
    footerView.priceLabel.text = [NSString stringWithFormat:@"￥%@", _order.totalPrice];
    NSArray *labels = @[footerView.orderNoLabel, footerView.createTimeLabel, footerView.finshTimeLabel, footerView.sureTimeLabel];
    if ([statusInfo.log count] == 4) {
        for (int i = 0; i < [statusInfo.log count]; i++) {
            UILabel *label = labels[i];
            NSDictionary *info = statusInfo.log[i];
            [label setText:[NSString stringWithFormat:@"%@ : %@", info[@"title"], info[@"time"]]];
        }
    }
    orderStore = [[MLOrderStore alloc] initWithAttributes:result[@"store"]];
    [infoTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return [goodsArray count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 240;
    } else if (indexPath.section == 1) {
        return 145;
    } else if (indexPath.section == 2) {
        return 120;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UITableViewCell";
    if (indexPath.section == 0) {
        MLOrderAddressCell *cell = (MLOrderAddressCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MLOrderAddressCell" owner:nil options:nil];
            cell = [nibs lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor whiteColor];
        }
        if (address && logistic) {
            cell.delegate = self;
            cell.addressLabel.text = address.address;
            [cell.addressLabel sizeToFit];
            cell.postCodeLabel.text = address.postcode;
            cell.phoneLabel.text = [NSString stringWithFormat:@"%@ %@", address.name, address.telephone];
            cell.logisticLabel.text = logistic.msg;
            cell.logisticTimeLabel.text = logistic.time;
        }
        return cell;
    } else if (indexPath.section == 1) {
        MLOrderStoreCell *cell = (MLOrderStoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MLOrderStoreCell" owner:nil options:nil];
            cell = [nibs lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if (orderStore && statusInfo) {
            cell.delegate = self;
            cell.storeNameLabel.text = orderStore.storeName;
            cell.orderStateLabel.text = statusInfo.current;
        }
        return cell;
    } else if (indexPath.section == 2) {
        MLOrderGoodsCell *cell = (MLOrderGoodsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MLOrderGoodsCell" owner:nil options:nil];
            cell = [nibs lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if ([goodsArray count] > 0) {
            MLGoods *goods = goodsArray[indexPath.row];
            cell.delegate = self;
            cell.goods = goods;
            cell.storeNameLabel.text = goods.name;
            cell.priceLabel.text = [NSString stringWithFormat:@"价格 : %@\t数量 : %@", goods.price, goods.quantityInCart];
            [cell.photoImageView setImageWithURL:[NSURL URLWithString:goods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
            cell.afterSaleLabel.text = goods.service[@"status"];
        }
        return cell;
    }
    return nil;
}

#pragma MLOrderAddressCellDelegate methods...
- (void)showLogisticInfo {
    if (address) {
//        MLOrderOperator
        if ([_order.operators count] > 0) {
            [[MLAPIClient shared] operateOrder:_order orderOperator:_order.operators[0] afterSalesGoods:nil withBlock:^(NSDictionary *attributes, MLResponse *response) {
                [self displayResponseMessage:response];
                if (response.success) {
                    NSLog(@"%@", attributes);
                    MLLogistic *logisticInfo = [[MLLogistic alloc] initWithAttributes:attributes];
                    MLLogisticViewController *logisticViewController = [[MLLogisticViewController alloc] initWithNibName:nil bundle:nil];
                    logisticViewController.logistic = logisticInfo;
                    [self.navigationController pushViewController:logisticViewController animated:YES];
                }
            }];
        }
    }
}

#pragma MLOrderGoodsCellDelegate methods;
- (void)applyAfterSale:(MLGoods *)goods {
    MLAskForAfterSalesViewController *afterSalesViewController = [MLAskForAfterSalesViewController new];
    MLAfterSalesGoods *afterSalesGoods = [[MLAfterSalesGoods alloc] init];
    afterSalesGoods.goodsID = goods.ID;
    afterSalesGoods.orderNO = _order.ID;
    afterSalesGoods.imagePath = goods.imagePath;
    afterSalesGoods.price = goods.price;
    afterSalesGoods.number = goods.quantityInCart;
    afterSalesGoods.status = goods.service[@"status"];
    afterSalesGoods.name = goods.name;
    afterSalesViewController.afterSalesGoods = afterSalesGoods;
    [self.navigationController pushViewController:afterSalesViewController animated:YES];
}

- (void)cancelAfterSale:(MLGoods *)goods {
    [self displayHUD:@"取消中..."];
    [[MLAPIClient shared] cancelService:_order.ID goodsId:goods.ID tradeId:goods.tradeid type:goods.service[@"type"] withBlock:^(NSDictionary *attributes, MLResponse *response) {
        [self displayResponseMessage:response];
        if (response.success) {
            NSLog(@"取消成功!");
        }
    }];
}

#pragma MLOrderStoreCellDelegate methods...
- (void)phoneButtonClick {
    if (orderStore) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", orderStore.telephone]]];
    }
}

- (void)showStoreDetail {
    NSLog(@"显示详情");
    if (orderStore) {
        MLStoreDetailsViewController *storeDetailViewController = [MLStoreDetailsViewController new];
        MLStore *store = [[MLStore alloc] init];
        store.ID = orderStore.storeId;
        storeDetailViewController.store = store;
        [self.navigationController pushViewController:storeDetailViewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        MLGoods *goods = goodsArray[indexPath.row];
        MLGoodsDetailsViewController *goodsDetailViewController = [MLGoodsDetailsViewController new];
        goodsDetailViewController.goods = goods;
        [self.navigationController pushViewController:goodsDetailViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
