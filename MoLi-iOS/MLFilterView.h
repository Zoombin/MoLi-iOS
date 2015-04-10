//
//  MLFilterView.h
//  MoLi
//
//  Created by imooly-mac on 15/4/7.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
#import "MLRowView.h"
@protocol MLFilterViewDelegate <NSObject>

-(void)filterViewRequestPramDictionary:(NSMutableDictionary*)dicpram;

-(void)filterViewattentionAlartMsg:(NSString*)msg;

@end


@interface MLFilterView : UIView<UITableViewDataSource,UITableViewDelegate,HeadViewDelegate,MLRowViewDelegate>{
    
    NSMutableArray *headViewArray;
    NSInteger _currentSection;
    NSInteger _currentRow;
    NSMutableArray *specArray;
    NSMutableArray *priceArray;
    UITextField *price1TextField;
    UITextField *price2TextField;
    NSMutableDictionary *parmDictionary;
    NSMutableDictionary *specTempDic;
    UIButton * pricetempButton;
    NSString * spectemp;
    NSString *parm_price;
    HeadView *headView_temp;
}

@property (weak, nonatomic) id<MLFilterViewDelegate> delegate;
@property (strong,nonatomic) UITableView *filterTable;
@property (strong, nonatomic) UIView *filterHeadView;
@property (strong, nonatomic) NSMutableArray *priceButtons;
@property(nonatomic, strong) NSMutableArray *specButtons;

- (void)loadModel:(NSMutableArray*)specListArr Price:(NSMutableArray*)priceArr;
@end



