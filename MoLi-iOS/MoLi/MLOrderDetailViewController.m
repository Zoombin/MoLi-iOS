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
#import "MLFlagshipStore.h"
#import "MLFlagshipStoreViewController.h"
#import "UIColor+ML.h"
#import "MLOrderOperator.h"
#import "MLAddress.h"
#import "MLAfterSalesLogisticViewController.h"
#import "MLSetWalletPasswordViewController.h"

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
    
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadOrderDetail) name:ML_NOTIFICATION_IDENTIFIER_REFRESH_ORDER_DETAILS object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadOrderDetail];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ML_NOTIFICATION_IDENTIFIER_REFRESH_ORDER_DETAILS object:nil];
}

- (void)loadOrderDetail {
    [self displayHUD:@"加载中..."];
    [[MLAPIClient shared] orderProfile:_order.ID withBlock:^(NSDictionary *attributes, MLResponse *response) {
        [self displayResponseMessage:response];
        if (response.success) {
            [self initData:attributes];
        }
    }];
}

- (void)initData:(NSDictionary *)result {
    address = [[MLOrderAddress alloc] initWithAttributes:result[@"address"]];
    goodsArray = [MLGoods createGoodsWithArray:result[@"goods"]];
    logistic = [[MLLogistic alloc] initWithAttributes:result[@"logistic"]];
    statusInfo = [[MLOrderStatusInfo alloc] initWithAttributes:result[@"status"]];
    footerView.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [_order.totalPrice floatValue]];
    float voucher = 0.0;
    if ([[result allKeys] containsObject:@"settle"]) {
        voucher = [result[@"settle"][@"voucher"] floatValue];
    }
    footerView.ticketMoneyLabel.text = [NSString stringWithFormat:@"￥%0.2f", voucher];
    NSArray *labels = @[footerView.createTimeLabel, footerView.finshTimeLabel, footerView.sendTimeLabel,footerView.sureTimeLabel];
    if ([statusInfo.log count] == 4) {
        for (int i = 0; i < [statusInfo.log count]; i++) {
            UILabel *label = labels[i];
            NSDictionary *info = statusInfo.log[i];
            [label setText:[NSString stringWithFormat:@"%@ : %@", info[@"title"], info[@"time"]]];
        }
    }
    footerView.orderNoLabel.text = [NSString stringWithFormat:@"订单编号 : %@", _order.ID];
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
            [cell.storeNameLabel sizeToFit];
            cell.priceLabel.text = [NSString stringWithFormat:@"价格 : %0.2f\t数量 : %@", goods.price.floatValue, goods.quantityInCart];
			cell.propertiesLabel.text = goods.goodsPropertiesString;
            [cell.photoImageView setImageWithURL:[NSURL URLWithString:goods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
            cell.afterSaleLabel.text = goods.service[@"status"];
        }
        return cell;
    }
    return nil;
}

- (void)buttonClicked:(MLGoods *)goods andCode:(MLOrderOperator *)operator {
    NSLog(@"%@", operator.code);
    if ([@"OP011" isEqualToString:operator.code]) {
        // OP011 申请售后
        [self applyAfterSale:goods];
    }
    if ([@"OP012" isEqualToString:operator.code]) {
        // OP012 填写物流信息
        MLAfterSalesGoods *afterSalesGoods = [[MLAfterSalesGoods alloc] init];
        afterSalesGoods.goodsID = goods.ID;
        afterSalesGoods.orderNO = _order.ID;
        afterSalesGoods.imagePath = goods.imagePath;
        afterSalesGoods.price = goods.price;
        afterSalesGoods.number = goods.quantityInCart;
        afterSalesGoods.status = goods.service[@"status"];
        afterSalesGoods.name = goods.name;
        afterSalesGoods.tradeID = goods.tradeid;
        afterSalesGoods.unique = goods.unique;
        MLAfterSalesLogisticViewController *afterSalesLogisticViewController = [MLAfterSalesLogisticViewController new];
        afterSalesLogisticViewController.afterSalesGoods = afterSalesGoods;
        [self.navigationController pushViewController:afterSalesLogisticViewController animated:YES];
    }
    if ([@"OP013" isEqualToString:operator.code]) {
        // OP013 取消售后
        [self cancelAfterSale:goods];
    }
    if ([@"OP014" isEqualToString:operator.code]) {
        // OP014 查看物流
        [self showLogistic:goods];
    }
    if ([@"OP015" isEqualToString:operator.code]) {
        // OP015 延迟收货
        NSLog(@"%d", operator.type);
        [self delayTake:goods];
    }
    if ([@"OP016" isEqualToString:operator.code]) {
        // OP016 确认收货
        [self displayHUD:@"加载中..."];
        [[MLAPIClient shared] userHasWalletPasswordWithBlock:^(NSNumber *hasWalletPassword, MLResponse *response) {
            [self displayResponseMessage:response];
            if (response.success) {
                if (hasWalletPassword.boolValue) {
                    NSString *message  = [NSString stringWithFormat:@"%.2f元", goods.price.floatValue];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认收货" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认收货", nil];
                    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
                    UITextField *textField = [alertView textFieldAtIndex:0];
                    textField.secureTextEntry = YES;
                    textField.placeholder = @"请输入交易密码";
                    [alertView show];
                    return;
                } else {
                    MLSetWalletPasswordViewController *setWalletPasswordViewController = [[MLSetWalletPasswordViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:setWalletPasswordViewController animated:YES];
                    return;
                }
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (!textField||!textField.text.length) {
            [self displayHUDTitle:nil message:@"请输入支付密码"];
            return;
        }
        NSString *password = textField.text;
        
        MLOrder *currentOrder = [[MLOrder alloc] init];
        currentOrder.ID = _order.ID;
        MLOrderOperator *currentOrderOperator = [[MLOrderOperator alloc] init];
        currentOrderOperator.type = MLOrderOperatorTypeConfirm;
        [[MLAPIClient shared] operateOrder:currentOrder orderOperator:currentOrderOperator afterSalesGoods:nil password:password withBlock:^(NSDictionary *attributes, MLResponse *response) {
            [self displayResponseMessage:response];
            if (response.success) {
                //TODO: 刷新
            }
        }];
    }
}

+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

- (void)showLogistic:(MLGoods *)goods {
    if (address) {
        [self displayHUD:@"加载中..."];
        if ([_order.operators count] > 0) {
            MLAfterSalesGoods *afterSalesGoods = [[MLAfterSalesGoods alloc] init];
            afterSalesGoods.goodsID = goods.ID;
            afterSalesGoods.orderNO = _order.ID;
            afterSalesGoods.imagePath = goods.imagePath;
            afterSalesGoods.price = goods.price;
            afterSalesGoods.number = goods.quantityInCart;
            afterSalesGoods.status = goods.service[@"status"];
            afterSalesGoods.name = goods.name;
            afterSalesGoods.tradeID = goods.tradeid;
            afterSalesGoods.unique = goods.unique;
            MLOrderOperator *currentOrderOperator = [[MLOrderOperator alloc] init];
            currentOrderOperator.type = MLOrderOperatorTypeLogistic;
            [[MLAPIClient shared] operateOrder:_order orderOperator:currentOrderOperator afterSalesGoods:afterSalesGoods password:nil withBlock:^(NSDictionary *attributes, MLResponse *response) {
                if (response.success) {
                    NSLog(@"%@", attributes);
                    [self displayResponseMessage:response];
                    MLLogistic *logisticInfo = [[MLLogistic alloc] initWithAttributes:attributes];
                    MLLogisticViewController *logisticViewController = [[MLLogisticViewController alloc] initWithNibName:nil bundle:nil];
                    logisticViewController.logistic = logisticInfo;
                    [self.navigationController pushViewController:logisticViewController animated:YES];
                } else {
                    [self displayHUDTitle:nil message:@"商家尚未发货,无法查看物流!"];
                }
            }];
        }
    }
}

#pragma MLOrderAddressCellDelegate methods...

- (void)showLogisticInfo:(MLOrderOperator *)operOperator {
    if (address) {
        [self displayHUD:@"加载中..."];
        if ([_order.operators count] > 0) {
			[[MLAPIClient shared] operateOrder:_order orderOperator:operOperator afterSalesGoods:nil password:nil withBlock:^(NSDictionary *attributes, MLResponse *response) {
                if (response.success) {
                    NSLog(@"%@", attributes);
                    [self displayResponseMessage:response];
                    MLLogistic *logisticInfo = [[MLLogistic alloc] initWithAttributes:attributes];
                    MLLogisticViewController *logisticViewController = [[MLLogisticViewController alloc] initWithNibName:nil bundle:nil];
                    logisticViewController.logistic = logisticInfo;
                    [self.navigationController pushViewController:logisticViewController animated:YES];
                } else {
                    [self displayHUDTitle:nil message:@"商家尚未发货,无法查看物流!"];
                }
            }];
        }
    }
}

- (void)delayTake:(MLGoods *)goods {
        MLAfterSalesGoods *afterSalesGoods = [[MLAfterSalesGoods alloc] init];
        afterSalesGoods.goodsID = goods.ID;
        afterSalesGoods.orderNO = _order.ID;
        afterSalesGoods.imagePath = goods.imagePath;
        afterSalesGoods.price = goods.price;
        afterSalesGoods.number = goods.quantityInCart;
        afterSalesGoods.status = goods.service[@"status"];
        afterSalesGoods.name = goods.name;
        afterSalesGoods.tradeID = goods.tradeid;
        afterSalesGoods.unique = goods.unique;
        [self displayHUD:@"加载中..."];
        MLOrderOperator *currentOrderOperator = [[MLOrderOperator alloc] init];
        currentOrderOperator.type = MLOrderOperatorTypeDelay;
        [[MLAPIClient shared] operateOrder:_order orderOperator:currentOrderOperator afterSalesGoods:afterSalesGoods password:nil withBlock:^(NSDictionary *attributes, MLResponse *response) {
            [self displayResponseMessage:response];
            if (response.success) {
                [self loadOrderDetail];
            }
        }];
}

#pragma MLOrderGoodsCellDelegate methods;

- (void)applyAfterSale:(MLGoods *)goods {
    MLAfterSalesGoods *afterSalesGoods = [[MLAfterSalesGoods alloc] init];
    afterSalesGoods.goodsID = goods.ID;
    afterSalesGoods.orderNO = _order.ID;
    afterSalesGoods.imagePath = goods.imagePath;
    afterSalesGoods.price = goods.price;
    afterSalesGoods.number = goods.quantityInCart;
    afterSalesGoods.status = goods.service[@"status"];
    afterSalesGoods.name = goods.name;
	afterSalesGoods.tradeID = goods.tradeid;
    MLOrderOperator *currentOrderOperator = [[MLOrderOperator alloc] init];
    currentOrderOperator.type = MLOrderOperatorTypeAfterSalesService;
        [self displayHUD:@"加载中..."];
		[[MLAPIClient shared] operateOrder:_order orderOperator:currentOrderOperator afterSalesGoods:afterSalesGoods password:nil withBlock:^(NSDictionary *attributes, MLResponse *response) {
			[self displayResponseMessage:response];
			if (response.success) {
				MLAskForAfterSalesViewController *afterSalesViewController = [[MLAskForAfterSalesViewController alloc] initWithNibName:nil bundle:nil];
				if ([response.data[@"address"] notNull]) {
					MLAddress *tmpAddress = [[MLAddress alloc] initWithAttributes:response.data[@"address"]];
					afterSalesViewController.address = tmpAddress;
				}
				afterSalesViewController.afterSalesGoods = afterSalesGoods;
				[self.navigationController pushViewController:afterSalesViewController animated:YES];
			}
		}];
}

- (void)cancelAfterSale:(MLGoods *)goods {
    [self displayHUD:@"取消中..."];
    [[MLAPIClient shared] cancelService:_order.ID goodsId:goods.ID tradeId:goods.tradeid type:goods.service[@"type"] withBlock:^(NSDictionary *attributes, MLResponse *response) {
        [self displayResponseMessage:response];
        if (response.success) {
            NSLog(@"取消成功!");
            [self loadOrderDetail];
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
        MLFlagshipStore *store = [[MLFlagshipStore alloc] init];
        store.ID = orderStore.storeId;
        store.name = orderStore.storeName;
        MLFlagshipStoreViewController *detailCtr = [[MLFlagshipStoreViewController alloc] initWithNibName:nil bundle:nil];
        detailCtr.flagshipStore = store;
        [self.navigationController pushViewController:detailCtr animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        MLGoods *goods = goodsArray[indexPath.row];
        MLGoodsDetailsViewController *goodsDetailViewController = [MLGoodsDetailsViewController new];
        goodsDetailViewController.goods = goods;
		goodsDetailViewController.previousViewControllerHidenBottomBar = YES;
        [self.navigationController pushViewController:goodsDetailViewController animated:YES];
    }
}

@end
