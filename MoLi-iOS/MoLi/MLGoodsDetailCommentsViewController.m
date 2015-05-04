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
#import "MLPagingView.h"
#import "MLBackToTopView.h"
#import "MLNoMoreDataFooter.h"

#define COMMENT_PAGE_SIZE 10

@interface MLGoodsDetailCommentsViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    MLGoodsCommentCellDelegate,
    MLBackToTopViewDelegate
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

@property (nonatomic,strong) NSMutableArray *arrayGoodComments;
@property (nonatomic,strong) NSMutableArray *arrayMidComments;
@property (nonatomic,strong) NSMutableArray *arrayBadComments;

@property (readwrite) UIImageView *fullScreenImageView;

@property (readwrite) BOOL noMore;
@property (readwrite) MLBackToTopView *backToTopView;
@property (readwrite) MLPagingView *pagingView;
@property (readwrite) NSInteger page;
@property (readwrite) NSInteger maxPage;

@end

@implementation MLGoodsDetailCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setLeftBarButtonItemAsBackArrowButton];
    self.title = @"用户评价";
    self.type = MLGoodsCommentTypeGood;
    self.page = 1;
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
    
    _fullScreenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width , self.view.bounds.size.height-64)];
    _fullScreenImageView.hidden = YES;
    _fullScreenImageView.backgroundColor = self.view.backgroundColor;
    _fullScreenImageView.contentMode = UIViewContentModeScaleAspectFit;
    _fullScreenImageView.userInteractionEnabled = YES;
    [self.view addSubview:_fullScreenImageView];
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFullScreenImageView)];
    [_fullScreenImageView addGestureRecognizer:hideTap];
    
    CGRect rect = CGRectZero;
    
        //  by hp 不含totalPagesize
//    rect.size.width = 44;
//    rect.size.height = 20;
//    rect.origin.x = (self.view.bounds.size.width - rect.size.width) / 2;
//    rect.origin.y = self.view.bounds.size.height - 40;
//    _pagingView = [[MLPagingView alloc] initWithFrame:rect];
//    [_pagingView updateMaxPage:99 currentPage:99];
//    [self.view addSubview:_pagingView];

    rect.origin.x = self.view.bounds.size.width - 50;
    rect.origin.y = self.view.bounds.size.height - 50;
    rect.size = [MLBackToTopView size];
    _backToTopView = [[MLBackToTopView alloc] initWithFrame:rect];
    _backToTopView.delegate = self;
    _backToTopView.hidden = YES;
    [self.view addSubview:_backToTopView];
    
    [self fetchCommentsData];
}

- (void)hideFullScreenImageView {
    _fullScreenImageView.hidden = YES;
}


//获取评论数据
- (void)fetchCommentsData
{
//    if (_noMore) {
//        return;
//    }
//        if (response.success) {
//            NSArray *array = [MLGoods multiWithAttributesArray:multiAttributes];
//            if (!array.count) {
//                _noMore = YES;
//            } else {
//                _maxPage = [[response.data[@"totalpage"] notNull] integerValue];
//                if (_page < _maxPage + 1) {
//                    _page++;
//                }
//                [_multiGoods addObjectsFromArray:array];
//            }
//            [_collectionView reloadData];
//        }
//    }];
//    
    
    
    NSString *flag = nil;
    if(self.type == MLGoodsCommentTypeGood)
        flag = @"good";
    else if(self.type == MLGoodsCommentTypeMiddle)
        flag = @"mid";
    else
        flag = @"bad";
    
    [self displayHUD:@"加载中..."];
    
    __weak __typeof(self)weakSelf = self;
    [[MLAPIClient shared] goodsComments:self.goods.ID commentFlag:flag currentPage:self.page withBlock:^(MLResponse *response) {
        [weakSelf displayResponseMessage:response];
        if (response.success) {
            weakSelf.commentResponse = response;
            [weakSelf updateData];
        }
        
        if ([weakSelf getCurrentDataSource].count>0) {
            weakSelf.tableView.hidden = NO;
        }
        else {
            weakSelf.tableView.hidden = YES;
        }
    }];
}

- (void)setCurrentDataSource
{
    NSArray *array = [self.commentResponse.data objectForKey:@"commentlist"];
    if (array.count==0) {
        _noMore = YES;
        return;
    }
    else if (array.count < COMMENT_PAGE_SIZE) {
        _noMore = YES;
    }
        
    
    if (_type == MLGoodsCommentTypeGood) {
        if (self.page == 1) {
            self.arrayGoodComments = [[NSMutableArray alloc] initWithArray:array];
        }
        else {
            [self.arrayGoodComments addObjectsFromArray:array];
        }
         self.page++;
    }
    else if (_type == MLGoodsCommentTypeMiddle) {
        if (self.page == 1) {
            self.arrayMidComments = [[NSMutableArray alloc] initWithArray:array];
        }
        else {
            [self.arrayMidComments addObjectsFromArray:array];
        }
        self.page++;
    }
    else {
        if (self.page == 1) {
            self.arrayBadComments = [[NSMutableArray alloc] initWithArray:array];
        }
        else {
            [self.arrayBadComments addObjectsFromArray:array];
        }
        self.page++;
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
    NSString *percent = [NSString stringWithFormat:@"好评率 : %@%%",[self.commentResponse.data objectForKey:@"highopinion"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:percent];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, percent.length - 4)];
    self.lblGoodCommentPercent.attributedText = attributedString;
    
    
    NSString *commentNum = [NSString stringWithFormat:@"累计评价 : %@",[self.commentResponse.data objectForKey:@"totalcomment"]];
    NSMutableAttributedString *attributedStringComment = [[NSMutableAttributedString alloc] initWithString:commentNum];
    [attributedStringComment addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, commentNum.length - 5)];
    self.lblCommentNum.attributedText = attributedStringComment;
    
    [self setCurrentDataSource];
    
    [_tableView reloadData];
}

// 创建顶部栏 好评率
- (UIView *)creatTopView
{
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0+64, WINSIZE.width, 44)];
    topview.backgroundColor = [UIColor whiteColor];
    
    self.lblGoodCommentPercent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, topview.frame.size.width/2.0, topview.frame.size.height)];
    self.lblGoodCommentPercent.textAlignment = NSTextAlignmentCenter;
    self.lblGoodCommentPercent.font = [UIFont systemFontOfSize:14];
    self.lblGoodCommentPercent.backgroundColor = [UIColor clearColor];
    self.lblGoodCommentPercent.textColor = [UIColor darkGrayColor];
    self.lblGoodCommentPercent.text = @"好评率 : 0%";
    [topview addSubview:self.lblGoodCommentPercent];
    
    self.lblCommentNum = [[UILabel alloc] initWithFrame:CGRectMake(topview.frame.size.width/2.0, 0, topview.frame.size.width/2.0, topview.frame.size.height)];
    self.lblCommentNum.textAlignment = NSTextAlignmentCenter;
    self.lblCommentNum.font = [UIFont systemFontOfSize:13];
    self.lblCommentNum.backgroundColor = [UIColor clearColor];
    self.lblCommentNum.textColor = [UIColor darkGrayColor];
    self.lblCommentNum.text = @"累计评价 : 0";
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
    self.btnGoodComment.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btnGoodComment.tag = MLGoodsCommentTypeGood;
    [self.btnGoodComment addTarget:self action:@selector(didSelectCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btnGoodComment];
    
    self.btnMiddleComment = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMiddleComment.frame = CGRectMake(view.frame.size.width/3.0, 0, view.frame.size.width/3.0, view.frame.size.height);
    [self.btnMiddleComment setTitle:@"中评" forState:UIControlStateNormal];
    self.btnMiddleComment.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btnMiddleComment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.btnMiddleComment.tag = MLGoodsCommentTypeMiddle;
    [self.btnMiddleComment addTarget:self action:@selector(didSelectCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btnMiddleComment];

    self.btnBadComment = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBadComment.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btnBadComment.frame = CGRectMake(view.frame.size.width/3.0*2, 0, view.frame.size.width/3.0, view.frame.size.height);
    [self.btnBadComment setTitle:@"差评" forState:UIControlStateNormal];
    [self.btnBadComment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.btnBadComment.tag = MLGoodsCommentTypeBad;
    [self.btnBadComment addTarget:self action:@selector(didSelectCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btnBadComment];

    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width/3.0, 5, 0.5, 34)];
    lineview.backgroundColor = [UIColor borderGrayColor];
    [view addSubview:lineview];
    
    lineview = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width/3.0*2, 5, 0.5, 34)];
    lineview.backgroundColor = [UIColor borderGrayColor];
    [view addSubview:lineview];
    
    self.orangeline = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-0.5, WINSIZE.width/3.0, 0.5)];
    self.orangeline.backgroundColor = [UIColor redColor];
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
    self.page = 1;
    [self fetchCommentsData];
}

// 修改评论按钮状态
- (void)changeCommentBtnState
{
    
    
    [self.btnGoodComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnMiddleComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnBadComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    if (self.type == MLGoodsCommentTypeGood) {
        [self.btnGoodComment setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.orangeline.center = CGPointMake(WINSIZE.width/6.0, 44-0.5);
    }
    else if (self.type == MLGoodsCommentTypeMiddle) {
        [self.btnMiddleComment setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.orangeline.center = CGPointMake(WINSIZE.width/6.0*3, 44-0.5);
    }
    else if (self.type == MLGoodsCommentTypeBad) {
        [self.btnBadComment setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.orangeline.center = CGPointMake(WINSIZE.width/6.0*5, 44-0.5);
    }
}

#pragma mark - MLBackToTopDelegate

- (void)willBackToTop {
    [self.tableView setContentOffset:CGPointZero animated:YES];
    _backToTopView.hidden = YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height) {
        [self fetchCommentsData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if(translation.y < 0) {
        _backToTopView.hidden = NO;
    }
    
    //  by hp 不含totalPagesize 不能显示当前第几页
//    float perPageHeight = 4*234;
//    int currentPaeg = (scrollView.contentOffset.y+scrollView.frame.size.height-70)/perPageHeight+1;
//    [_pagingView updateMaxPage:_maxPage currentPage:currentPaeg];
//    [_pagingView updateMaxPage:_maxPage currentPage:currentPaeg];
}


#pragma mark - UITabelViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_noMore) {
        return  [MLNoMoreDataFooter height];
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_noMore) {
        UIView *noView = [[MLNoMoreDataFooter alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [MLNoMoreDataFooter height])];
        return noView;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGoodsCommentCell *cell = [[MLGoodsCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[MLGoodsCommentCell identifier]];
    NSArray *arrayDataSource = [self getCurrentDataSource];
    
    MLGoodsCommentModel *model = [MLGoodsCommentModel modelWithDictionary:arrayDataSource[indexPath.row]];
    
    [cell setShowInfo:model];
    return cell.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSArray *array = [self.commentResponse.data objectForKey:@"commentlist"];
//    if(array.count>0)
//        return array.count;
//    else
//        return 0;
   return [[self getCurrentDataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
    if (!cell) {
        cell = [[MLGoodsCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[MLGoodsCommentCell identifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    NSArray *arrayDataSource = [self getCurrentDataSource];
    MLGoodsCommentModel *model = [MLGoodsCommentModel modelWithDictionary:arrayDataSource[indexPath.row]];
    [cell setShowInfo:model];
    
    
    return cell;
}


#pragma mark - CommentCell Delegate
- (void)didPressedImage:(NSString *)imageStr
{
    _fullScreenImageView.hidden = NO;
    [_fullScreenImageView setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}

@end
