//
//  MLPayFailViewController.m
//  TestCelectionView
//
//  Created by imooly-mac on 15/4/1.
//  Copyright (c) 2015年 imooly-mac. All rights reserved.
//

#import "MLPayFailViewController.h"
#import "MLPayFailView.h"
@interface MLPayFailViewController ()<payFailDelegate>

@end

@implementation MLPayFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付失败";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    MLPayFailView *payView = [[MLPayFailView alloc] initWithFrame:self.view.bounds];
    payView.delegate = self;

    payView.errormsgLabel.text = @"未知错误：请稍后检查交易记录确认交易结果！";
    
    [self.view addSubview:payView];
}

//重新支付
-(void)goingPaybtnClick{

    NSLog(@"点击了重新支付按钮");
}

//随便逛逛
-(void)lookingAroundbtnClick{

    NSLog(@"点击了随便逛逛按钮");
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
