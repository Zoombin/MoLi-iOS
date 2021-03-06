//
//  MLFilterView.m
//  MoLi
//
//  Created by imooly-mac on 15/4/7.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLFilterView.h"

@interface MLFilterView () <UITextFieldDelegate>

@end

@implementation MLFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        parmDictionary = [NSMutableDictionary dictionary];
		_specButtons = [NSMutableArray array];
        _priceButtons = [NSMutableArray array];
        parm_price = @"";
        specTempDic = [NSMutableDictionary dictionary];
        rowArr = [NSMutableArray array];
    }
    return self;
}

- (void)initFilterView:(NSMutableArray*)pricearr {
    
    [pricearr insertObject:@"不限" atIndex:0];

    int row = [pricearr count] % 3;
    if (row) {
        row = (int)[pricearr count] / 3 + 1;
    } else {
        row = [pricearr count] / 3;
    }
    CGRect rect = self.frame;
    rect.size.height = 112 / 2 + row * 30 + 20 + 130;
    _filterHeadView = [[UIView alloc] initWithFrame:rect];
//    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 40, 20)];
//    priceLabel.text = @"价格";
//    priceLabel.backgroundColor = [UIColor clearColor];
//    [priceLabel setTextColor:[UIColor grayColor]];
//    [priceLabel setFont:[UIFont systemFontOfSize:14.0f]];
//    [_filterHeadView addSubview:priceLabel];
//    
//    price1TextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame), 16, 80, 30)];
//    price1TextField.layer.cornerRadius = 3;
//    price1TextField.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
//    [price1TextField setTextColor:[UIColor lightGrayColor]];
//	price1TextField.keyboardType = UIKeyboardTypeNumberPad;
//	price1TextField.delegate = self;
//
//    price1TextField.layer.borderWidth = 0.5;
//    [_filterHeadView addSubview:price1TextField];
//    
//    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(price1TextField.frame)+10, 30, 15, 1)];
//    [line setBackgroundColor:[UIColor lightGrayColor]];
//    [_filterHeadView addSubview:line];
//    
//    price2TextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+10, 16, 80, 30)];
//    [price2TextField setTextColor:[UIColor lightGrayColor]];
//    price2TextField.layer.borderWidth = 0.5;
//    price2TextField.layer.cornerRadius = 3;
//    price2TextField.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
//	price2TextField.keyboardType = UIKeyboardTypeNumberPad;
//	price2TextField.delegate = self;
//    [_filterHeadView addSubview:price2TextField];
    
    [self creatBtutton:pricearr];
}

- (void)creatBtutton:(NSMutableArray*)array {
    for (UIButton *button in _priceButtons) {
        [button removeFromSuperview];
    }
    
//    NSInteger numberPerLine = 3;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(19, 16, 19, 10);
    CGFloat buttonWidth = 65;
    if ([UIScreen mainScreen].bounds.size.width > 320) {
        buttonWidth = 85;
    }
    CGRect rect = CGRectMake(edgeInsets.left, edgeInsets.top, buttonWidth, 32);

    for	(int i = 0; i < array.count;) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        CGFloat buttonLeftRightWith=20;
        CGFloat totalWidth = CGRectGetWidth(self.frame)-30;
        rect.size.width = [self widthButton:array[i]]>totalWidth?totalWidth:[self widthButton:array[i]]+buttonLeftRightWith;

//        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.frame = rect;
        [button addTarget:self action:@selector(selectPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
        i++;
//        rect.origin.x += rect.size.width + edgeInsets.left;
//        if (i % numberPerLine == 0) {
//            rect.origin.x = edgeInsets.left;
//            rect.origin.y += rect.size.height + edgeInsets.bottom - 10;
//        }
        CGFloat visiableWith = CGRectGetWidth(self.frame)-CGRectGetMaxX(button.frame);
        
        CGFloat nextButtonSizeTitleWidth;
        
        if (i<[array count]) {
            nextButtonSizeTitleWidth = [self widthButton:array[i]]+buttonLeftRightWith;
        }
        
        if (visiableWith<nextButtonSizeTitleWidth+20) {
            
            rect.origin.y = CGRectGetMaxY(button.frame)+15;
            rect.origin.x = 15;
        }else{
            rect.origin.x = CGRectGetMaxX(button.frame)+10;
            
        }

        [button drawDashedBorderwithColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
        [_filterHeadView addSubview:button];
        [_priceButtons addObject:button];
    }
//    [_filterHeadView setBackgroundColor:[UIColor greenColor]];
    UIButton *lastBtn = [_priceButtons lastObject];
    CGFloat maxYBtn = CGRectGetMaxY(lastBtn.frame);
    UIView *locaRowView = [[UIView alloc] initWithFrame:CGRectMake(0, maxYBtn+5,CGRectGetWidth(self.frame), 70)];
    CGFloat maxYloca = CGRectGetMaxY(locaRowView.frame);
    CGRect recty = _filterHeadView.frame;
    recty.size.height = maxYloca;
    _filterHeadView.frame = recty;
    locaRowView.layer.borderColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1].CGColor;
    locaRowView.layer.borderWidth = 0.4;
    [locaRowView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1]];
    [_filterHeadView addSubview:locaRowView];
    //只是在界面上移除了"仅显示有货商品"选项
    NSArray *arrtitle = @[@"能获得代金券"];
    
    for (int i = 0; i < [arrtitle count]; i++) {
        MLRowView *rowview = [[MLRowView alloc] initWithFrame:CGRectMake(0, 11+60*i, CGRectGetWidth(locaRowView.frame), 48)];
        rowview.rowname.text = arrtitle[i];
        rowview.delegate = self;
        rowview.tag = 2601;
        [rowview.rowimageview setImage:[UIImage imageNamed:@"GoodsUnselected"]];//
        [rowview setBackgroundColor:[UIColor whiteColor]];
        [locaRowView addSubview:rowview];
        [rowArr addObject:rowview];
    }
    
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	for (UIButton *btn in _priceButtons) {
		[btn setBackgroundColor:[UIColor whiteColor]];
		[btn drawDashedBorderwithColor:[UIColor whiteColor]];
		[btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}
	pricetempButton = nil;
}


#pragma mark MLRowViewDelegate

- (void)selectRowView:(MLRowView *)rowview {
    
    if (rowview.isSelect) {
        
        rowview.isSelect = NO;
        rowview.rowname.textColor = [UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:1];
        [rowview.rowimageview setImage:[UIImage imageNamed:@"GoodsUnselected"]];
        [self parmState:rowview.tag isRomveFromDic:YES];
    } else {
         rowview.isSelect = YES;
        rowview.rowname.textColor = [UIColor colorWithRed:226/255.0 green:37/255.0 blue:5/255.0 alpha:1];
        [rowview.rowimageview setImage:[UIImage imageNamed:@"GoodsSelected"]];
        [self parmState:rowview.tag isRomveFromDic:NO];
    }
}

-(void)parmState:(NSInteger)viewTag isRomveFromDic:(BOOL)flag{

    switch (viewTag-2600) {
        case 0:{
            flag?[parmDictionary setObject:@0 forKey:@"stockflag"]:[parmDictionary setObject:@1 forKey:@"stockflag"];
        }
            
            break;
        case 1:{
            flag?[parmDictionary setObject:@0 forKey:@"voucherflag"]:[parmDictionary setObject:@1 forKey:@"voucherflag"];
        }
            
            break;
            
        default:
            break;
    }
}


- (void)selectPriceBtn:(UIButton*)btn{
	[self endEditing:YES];
	
    parm_price = [btn titleForState:UIControlStateNormal];
//    [self putButtonTitleInToTextField:parm_price];
    [parmDictionary setObject:parm_price forKey:@"price"];
    pricetempButton = btn;
    [btn setBackgroundColor:[UIColor themeColor]];
//    btn.layer.borderWidth = 0;
    [btn drawDashedBorderwithColor:[UIColor clearColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    for(UIButton *tempbtn in _priceButtons){
        if (tempbtn != btn) {
            [tempbtn drawDashedBorderwithColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
            [tempbtn setBackgroundColor:[UIColor whiteColor]];
            [tempbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}
/*
-(void)putButtonTitleInToTextField:(NSString*)btnTitle{
     price1TextField.text = @"";
     price2TextField.text = @"";
     NSString *price1;
     NSString *price2;
    if ([btnTitle rangeOfString:@"以上"].location !=NSNotFound) {
        NSUInteger loact = [btnTitle rangeOfString:@"以上"].location;
        price1 = [btnTitle substringToIndex:loact];
        
    }else{
        if ([btnTitle rangeOfString:@"不限"].location !=NSNotFound) {
            return;
        }
        NSArray *pricearr = [btnTitle componentsSeparatedByString:@"-"];
        if ([pricearr count]==2) {
//            price1 = [pricearr[0] intValue]>=[pricearr[1] intValue]?pricearr[0]:pricearr[1];
//            price2 = [pricearr[0] intValue]>=[pricearr[1] intValue]?pricearr[1]:pricearr[0];
            price1 = pricearr[0];
            price2 = pricearr[1];
        }
    }
    
    if (price1) {
        price1TextField.text = price1;
    }
    if (price2) {
        price2TextField.text = price2;
    }

}
*/
- (void)loadModel:(NSMutableArray*)specListArr Price:(NSMutableArray*)priceArr {
    [self initFilterView:priceArr];
    _filterTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-48-20)];
    _filterTable.layer.borderColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1].CGColor;
    _filterTable.layer.borderWidth = 0.6;
    [_filterTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_filterTable setTableHeaderView:_filterHeadView];
    [_filterTable setBackgroundColor:[UIColor whiteColor]];
    [_filterTable setDataSource:self];
    [_filterTable setDelegate:self];
    [self addSubview:_filterTable];
    specArray = specListArr;
    priceArray = priceArr;
    _currentRow = 0;
    headViewArray = [[NSMutableArray alloc]init];
    for(int i = 0;i< specListArr.count ;i++)
    {
        HeadView* headview = [[HeadView alloc] init];
        headview.backgroundColor = [UIColor whiteColor];
        headview.backBtn.backgroundColor = [UIColor clearColor];
        headview.delegate = self;
        headview.section = i;
        NSString *titleStr = [[specListArr objectAtIndex:i]objectForKey:@"name"];
        if (titleStr) {
            headview.nameLabel.text = titleStr;
            headview.nameLabel.font = [UIFont systemFontOfSize:15.0];
            headview.nameLabel.textColor = [UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:1];
        }
        [headview.backBtn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        if (i > 0) {
            headview.topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
            headview.topLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        }
        
        if (i == specListArr.count - 1 ) {
            headview.buttomLine.frame = CGRectMake(0, 47.5, CGRectGetWidth(self.frame), 0.5);
            headview.buttomLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];;
        }
        [headViewArray addObject:headview];
    }
    
    UIView *bottonview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-48, CGRectGetWidth(self.frame), 48)];
    [bottonview setBackgroundColor:[UIColor colorWithWhite:243/255.0 alpha:1]];
    [self addSubview:bottonview];
    
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-78-10, 9, 78, 32)];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [clearBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    clearBtn.layer.cornerRadius = 5;
    clearBtn.layer.borderColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1].CGColor;
    clearBtn.layer.borderWidth = 1.0f;
    [bottonview addSubview:clearBtn];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2+10, 9, 78, 32)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor themeColor]];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
     sureBtn.layer.cornerRadius = 5;
    [bottonview addSubview:sureBtn];
}


-(void)clearbtnClick {
    price1TextField.text = @"";
    price2TextField.text = @"";
    parm_price = @"";
    [parmDictionary removeAllObjects];
    [pricetempButton drawDashedBorderwithColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    [pricetempButton setBackgroundColor:[UIColor whiteColor]];
    [pricetempButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    for (HeadView *headview in headViewArray) {
        headview.chooseNoteLabel.text = @"";
    }
    if (headView_temp.open) {
      [self selectedWith:headView_temp];
    }
    
    [specTempDic removeAllObjects];
    for(MLRowView *rowview in rowArr){
        rowview.isSelect = NO;
        rowview.rowname.textColor = [UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:1];
        [rowview.rowimageview setImage:[UIImage imageNamed:@"GoodsUnselected"]];
    }
}


- (void)sureBtnClick{
    
    NSString *pricestr1 = [price1TextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *pricestr2 = [price2TextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (pricestr1 && pricestr2 && ![pricestr1 isEqualToString:@""]&& ![pricestr2 isEqualToString:@""]) {
        NSString *tempstr;
        if ([pricestr1 intValue]>[pricestr2 intValue]) {
            tempstr = pricestr1;
            pricestr1 = pricestr2;
            pricestr2 = tempstr;
        }
        parm_price = [NSString stringWithFormat:@"%@-%@",pricestr1,pricestr2];
    }
    
    if ((pricestr1 && ![pricestr1 isEqualToString:@""]) && (!pricestr2 || [pricestr2 isEqualToString:@""])) {
        parm_price = [pricestr1 stringByAppendingString:@"以上"];
    }
    [parmDictionary removeObjectForKey:@"spec"];
    NSMutableArray *arrays = [NSMutableArray array];
    for (NSString *key in [specTempDic allKeys]) {
        if ([specTempDic[key]isEqualToString:@"不限"]) {
            
            continue;
        }
        [arrays addObject:[NSString stringWithFormat:@"%@:%@",key,specTempDic[key]]];
    }
    if ([arrays count]!=0) {
        NSString *spec = [arrays componentsJoinedByString:@";"];
        if (spec) {
            [parmDictionary setObject:spec forKey:@"spec"];
        }

    }
        if (parm_price) {
        if (![parm_price isEqualToString:@"不限"]) {
           [parmDictionary setObject:parm_price forKey:@"price"];
        }else{
            if (parmDictionary[@"price"]) {
                [parmDictionary removeObjectForKey:@"price"];
            }
        
        }
    }
   
    if (_delegate &&[_delegate respondsToSelector:@selector(filterViewRequestPramDictionary:)]) {
        [_delegate filterViewRequestPramDictionary:parmDictionary];
    }
}


#pragma mark - HeadViewdelegate
- (void)selectedWith:(HeadView *)view {
    headView_temp.boardLine = 0;
    headView_temp.buttomLine.hidden = NO;
    view.boardLine = 1;
    headView_temp = view;
    _currentRow = 0;
    spectemp = view.nameLabel.text;
    
    if (view.open) {
        for(int i = 0;i<[headViewArray count];i++)
        {
            HeadView *head = [headViewArray objectAtIndex:i];
            head.open = NO;
            [head.imageView setImage:[UIImage imageNamed:@"RightArrow"]];
        }
        for (UIButton *button in _specButtons) {
            
            [button removeFromSuperview];
        }
        [_specButtons removeAllObjects];
        
        [_filterTable reloadData];
         view.boardLine = 0;
        view.buttomLine.hidden = NO;
        return;
    }
    view.buttomLine.hidden = YES;
    _currentSection = view.section;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:_currentSection];

     UITableViewCell *cell = [_filterTable cellForRowAtIndexPath:indexpath];
    NSMutableArray *temarr = [NSMutableArray arrayWithArray:[[specArray objectAtIndex:_currentSection]objectForKey:@"list"]];
    [self creatBtutton:temarr filtercell:cell];
    [self selectColorButton];
    [self reset];


}

- (void)selectColorButton {
        if (specTempDic[spectemp]) {
            NSString *str = specTempDic[spectemp];
            for (UIButton*btn in _specButtons) {
            NSString *btnTitle = [btn titleForState:UIControlStateNormal];
               if ([str isEqualToString:btnTitle]) {
                   [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
                   [btn drawDashedBorderwithColor:[UIColor themeColor]];
                }
             }
        } else {
            for (UIButton*btn in _specButtons) {
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [btn drawDashedBorderwithColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
            }
        }
}

//  界面重置
- (void)reset {
    for(int i = 0;i<[headViewArray count];i++) {
        HeadView *head = [headViewArray objectAtIndex:i];
        if(head.section == _currentSection) {
            head.open = YES;
            [head.imageView setImage:[UIImage imageNamed:@"DownArrow"]];
        } else {
            head.open = NO;
			[head.imageView setImage:[UIImage imageNamed:@"RightArrow"]];
		}
    }
    [_filterTable reloadData];
}


- (void)creatBtutton:(NSMutableArray*)array filtercell:(UITableViewCell*)cell {


   [array insertObject:@"不限" atIndex:0];

    for (UIButton *button in _specButtons) {
        [button removeFromSuperview];
    }
    [_specButtons removeAllObjects];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(19, 15, 19, 10);
    CGFloat buttonWidth = 73;
    if ([UIScreen mainScreen].bounds.size.width > 320) {
        buttonWidth = 85;
    }
    CGRect rect = CGRectMake(edgeInsets.left, edgeInsets.top, buttonWidth, 32);
    for	(int i = 0; i < array.count;) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *titles = array[i];

        [button setTitle:titles forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        button.titleLabel.numberOfLines = 2;
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
        CGFloat buttonLeftRightWith=20;
        CGFloat totalWidth = CGRectGetWidth(self.frame)-30;
        rect.size.width = [self widthButton:titles]>totalWidth?totalWidth:[self widthButton:titles]+buttonLeftRightWith;
        button.frame = rect;
        button.tag = 3000+i;
        [button addTarget:self action:@selector(selectSpecButton:) forControlEvents:UIControlEventTouchUpInside];
        i++;
        

        CGFloat visiableWith = CGRectGetWidth(self.frame)-CGRectGetMaxX(button.frame);

        CGFloat nextButtonSizeTitleWidth;
  
        if (i<[array count]) {
            nextButtonSizeTitleWidth = [self widthButton:array[i]]+buttonLeftRightWith;
        }
        
        if (visiableWith<nextButtonSizeTitleWidth+20) {

            rect.origin.y = CGRectGetMaxY(button.frame)+15;
             rect.origin.x = 15;
        }else{
            rect.origin.x = CGRectGetMaxX(button.frame)+10;
        
        }

        [button drawDashedBorderwithColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
        [cell addSubview:button];
        [_specButtons addObject:button];
    }
}


-(CGFloat)widthButton:(NSString*)titlestr{
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
   CGSize sizetitle = [titlestr sizeWithAttributes:attribute];

    if (sizetitle.width<50) {
        sizetitle.width = 50;
    }
    
    return sizetitle.width;
}

- (void)selectSpecButton:(UIButton*)btn {
    NSString *titlestr = [btn titleForState:UIControlStateNormal];
    headView_temp.chooseNoteLabel.text = titlestr;
    [specTempDic setObject:titlestr forKey:spectemp];
    [self selectedWith:headView_temp];
    [btn drawDashedBorderwithColor:[UIColor themeColor]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadView* headView = [headViewArray objectAtIndex:indexPath.section];
//     NSArray *arr = [[specArray objectAtIndex:indexPath.section] objectForKey:@"list"];
    
//    int row = 0;
//    if (_specButtons.count % 3 == 0) {
//        row = _specButtons.count / 3;
//	} else {
//        row = (int)_specButtons.count/3 + 1;
//    }
    
    UIButton *btn = [_specButtons lastObject];
    CGFloat maxYbtn = CGRectGetMaxY(btn.frame);
    HeadView* lastheadView = [headViewArray lastObject];
    if (headView_temp==lastheadView) {

        CGRect rects = CGRectMake(0, maxYbtn+10, 320, 0.5);
        if (lastLine==nil) {
            lastLine = [[UIImageView alloc] initWithFrame:rects];
            
            [lastLine setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];

            UITableViewCell *cell = [_filterTable cellForRowAtIndexPath:indexPath];
            [cell addSubview:lastLine];
        }
        
    }

    return headView.open ? maxYbtn+20 : 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [headViewArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return headViewArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identiferstr = [NSString stringWithFormat:@"cell%d%d",(int)indexPath.section,(int)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identiferstr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identiferstr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    if ([identiferstr isEqualToString:@"cell30"]) {
//        UIButton *bttt = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
//        [bttt setBackgroundColor:[UIColor redColor]];
//        [cell addSubview:bttt];
//    }
    
//    [cell setBackgroundColor:[UIColor yellowColor]];
    return cell;
}

@end
