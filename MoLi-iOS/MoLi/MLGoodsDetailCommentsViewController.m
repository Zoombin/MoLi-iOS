//
//  MLGoodsDetailCommentsViewController.m
//  MoLi
//
//  Created by LLToo on 15/4/16.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLGoodsDetailCommentsViewController.h"
#import "MLAPIClient.h"
#import "MLGoodsCommentCell.h"

@interface MLGoodsDetailCommentsViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *lblGoodCommentPercent;   //显示好评率
@property (nonatomic,strong) UILabel *lblCommentNum;        //显示评价数

@property (nonatomic,strong) UIButton *btnGoodComment;
@property (nonatomic,strong) UIButton *btnMiddleComment;
@property (nonatomic,strong) UIButton *btnBadComment;
@property (nonatomic,strong) UIView *orangeline;

@property (nonatomic,assign) MLGoodsCommentType type;       //标记当前哪种评价
@property (nonatomic,strong) MLResponse *commentResponse;

@property (nonatomic,assign) int  currentPage;
@property (nonatomic,strong) NSMutableArray *arrayGoodComments;
@property (nonatomic,strong) NSMutableArray *arrayMidComments;
@property (nonatomic,strong) NSMutableArray *arrayBadComments;

@end

@implementation MLGoodsDetailCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    [self setLeftBarButtonItemAsBackArrowButton];
    self.title = @"用户评价";
    self.type = MLGoodsCommentTypeGood;
    self.currentPage = 1;
    UIView *topview = [self creatTopView];
    [self.view addSubview:topview];
    
    UIView *commentBtnView = [self createChangeCommentView];
    [self.view addSubview:commentBtnView];
    
    [self changeCommentBtnState];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44*2, WINSIZE.width, self.view.bounds.size.height-64-44*2) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    [self fetchCommentsData];
}


//获取评论数据
- (void)fetchCommentsData
{
    NSString *flag = nil;
    if(self.type == MLGoodsCommentTypeGood)
        flag = @"good";
    else if(self.type == MLGoodsCommentTypeMiddle)
        flag = @"mid";
    else
        flag = @"bad";
    
    [self displayHUD:@"加载中..."];
    [[MLAPIClient shared] goodsComments:self.goods.ID commentFlag:flag currentPage:self.currentPage withBlock:^(MLResponse *response) {
        [self displayResponseMessage:response];
        if (response.success) {
            NSLog(@"--->%@",response.data);
            self.commentResponse = response;
            [self updateData];
        }
    }];
}

- (void)setCurrentDataSource
{
    NSArray *array = [self.commentResponse.data objectForKey:@"commentlist"];
    if (array.count==0) {
        return;
    }
    
    if (_type == MLGoodsCommentTypeGood) {
        if (self.currentPage == 1) {
            self.arrayGoodComments = [[NSMutableArray alloc] initWithArray:array];
        }
        else {
            [self.arrayGoodComments addObjectsFromArray:array];
        }
    }
    else if (_type == MLGoodsCommentTypeMiddle) {
        if (self.currentPage == 1) {
            self.arrayMidComments = [[NSMutableArray alloc] initWithArray:array];
        }
        else {
            [self.arrayMidComments addObjectsFromArray:array];
        }
    }
    else {
        if (self.currentPage == 1) {
            self.arrayBadComments = [[NSMutableArray alloc] initWithArray:array];
        }
        else {
            [self.arrayBadComments addObjectsFromArray:array];
        }
    }
}

- (NSArray *)getCurrentDataSource
{
    if (_type == MLGoodsCommentTypeGood) {
        return self.arrayGoodComments;
    }
    else if (_type == MLGoodsCommentTypeMiddle) {
        return self.arrayMidComments;
    }
    else {
        return self.arrayBadComments;
    }
}

// 更新界面数据
- (void)updateData
{
    NSString *percent = [self.commentResponse.data objectForKey:@"highopinion"];
    self.lblGoodCommentPercent.text = [NSString stringWithFormat:@"好评率:%@%%",percent];
    
    NSString *commentNum = [self.commentResponse.data objectForKey:@"totalcomment"];
    self.lblCommentNum.text = [NSString stringWithFormat:@"累计评价:%@",commentNum];
    
    [self setCurrentDataSource];
    
    [_tableView reloadData];
}

// 创建顶部栏 好评率
- (UIView *)creatTopView
{
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0+64, WINSIZE.width, 44)];
    
    self.lblGoodCommentPercent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, topview.frame.size.width/2.0, topview.frame.size.height)];
    self.lblGoodCommentPercent.textAlignment = NSTextAlignmentCenter;
    self.lblGoodCommentPercent.font = [UIFont systemFontOfSize:13];
    self.lblGoodCommentPercent.backgroundColor = [UIColor clearColor];
    self.lblGoodCommentPercent.textColor = [UIColor darkGrayColor];
    self.lblGoodCommentPercent.text = @"好评率:0%";
    [topview addSubview:self.lblGoodCommentPercent];
    
    self.lblCommentNum = [[UILabel alloc] initWithFrame:CGRectMake(topview.frame.size.width/2.0, 0, topview.frame.size.width/2.0, topview.frame.size.height)];
    self.lblCommentNum.textAlignment = NSTextAlignmentCenter;
    self.lblCommentNum.font = [UIFont systemFontOfSize:13];
    self.lblCommentNum.backgroundColor = [UIColor clearColor];
    self.lblCommentNum.textColor = [UIColor darkGrayColor];
    self.lblCommentNum.text = @"累计评价: 0";
    [topview addSubview:self.lblCommentNum];
    
    return topview;
}

// 创建切换好评差评栏
- (UIView *)createChangeCommentView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44+64, WINSIZE.width, 44)];
    view.backgroundColor = [UIColor customGrayColor];
    
    self.btnGoodComment = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnGoodComment.frame = CGRectMake(0, 0, view.frame.size.width/3.0, view.frame.size.height);
    [self.btnGoodComment setTitle:@"好评" forState:UIControlStateNormal];
    [self.btnGoodComment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.btnGoodComment.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btnGoodComment.tag = MLGoodsCommentTypeGood;
    [self.btnGoodComment addTarget:self action:@selector(didSelectCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btnGoodComment];
    
    self.btnMiddleComment = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMiddleComment.frame = CGRectMake(view.frame.size.width/3.0, 0, view.frame.size.width/3.0, view.frame.size.height);
    [self.btnMiddleComment setTitle:@"中评" forState:UIControlStateNormal];
    self.btnMiddleComment.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btnMiddleComment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.btnMiddleComment.tag = MLGoodsCommentTypeMiddle;
    [self.btnMiddleComment addTarget:self action:@selector(didSelectCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btnMiddleComment];

    self.btnBadComment = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBadComment.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btnBadComment.frame = CGRectMake(view.frame.size.width/3.0*2, 0, view.frame.size.width/3.0, view.frame.size.height);
    [self.btnBadComment setTitle:@"差评" forState:UIControlStateNormal];
    [self.btnBadComment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.btnBadComment.tag = MLGoodsCommentTypeBad;
    [self.btnBadComment addTarget:self action:@selector(didSelectCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btnBadComment];


    self.orangeline = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-0.5, WINSIZE.width/3.0, 0.5)];
    self.orangeline.backgroundColor = [UIColor orangeColor];
    [view addSubview:self.orangeline];
    
    return view;
}


- (void)didSelectCommentBtn:(UIButton *)btn
{
    if (self.type == btn.tag) {
        return;
    }
    
    self.type = btn.tag;
    [self changeCommentBtnState];
    [self fetchCommentsData];
}

// 修改评论按钮状态
- (void)changeCommentBtnState
{
    
    
    [self.btnGoodComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnMiddleComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnBadComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    if (self.type == MLGoodsCommentTypeGood) {
        [self.btnGoodComment setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.orangeline.center = CGPointMake(WINSIZE.width/6.0, 44-0.5);
    }
    else if (self.type == MLGoodsCommentTypeMiddle) {
        [self.btnMiddleComment setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.orangeline.center = CGPointMake(WINSIZE.width/6.0*3, 44-0.5);
    }
    else if (self.type == MLGoodsCommentTypeBad) {
        [self.btnBadComment setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.orangeline.center = CGPointMake(WINSIZE.width/6.0*5, 44-0.5);
    }
}


#pragma mark - UITabelViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGoodsCommentCell *cell = [[MLGoodsCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[MLGoodsCommentCell identifier]];
    NSArray *arrayDataSource = [self getCurrentDataSource];
    [cell setShowInfo:arrayDataSource[indexPath.row]];
    return cell.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.commentResponse.data objectForKey:@"commentlist"];
    if(array.count>0)
        return array.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
    if (!cell) {
        cell = [[MLGoodsCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[MLGoodsCommentCell identifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *arrayDataSource = [self getCurrentDataSource];
    [cell setShowInfo:arrayDataSource[indexPath.row]];
    
    
    return cell;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MLAfterSaleServiceDetailViewController *afterServiceCtr = [[MLAfterSaleServiceDetailViewController alloc] init];
//    afterServiceCtr.afterGoods = _multiAfterSalesGoods[indexPath.section];
//    [self.navigationController pushViewController:afterServiceCtr animated:YES];
//}



@end
