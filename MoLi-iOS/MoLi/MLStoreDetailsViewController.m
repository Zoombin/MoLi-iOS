//
//  MLStoreDetailsViewController.m
//  MoLi
//
//  Created by zhangbin on 12/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLStoreDetailsViewController.h"
#import "Header.h"
#import "MLStoreDetailsTableViewCell.h"
#import "MLStoreMemberPrivilegeTableViewCell.h"
#import "MLStoreCommentTableViewCell.h"
#import "MLStoreComment.h"
#import "MLStoreCommentViewController.h"
//#import "MLMapViewController.h"

@interface MLStoreDetailsViewController () <
MLStoreDetailsTableViewCellDelegate,
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UMSocialUIDelegate
>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *sectionClasses;
@property (readwrite) NSArray *storeComments;
@property (readwrite) BOOL sharing;

@end

@implementation MLStoreDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"实体折扣店", nil);
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_sectionClasses = @[[MLStoreDetailsTableViewCell class], [MLStoreMemberPrivilegeTableViewCell class], [MLStoreCommentTableViewCell class]];
	
	UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
	
	UIBarButtonItem *favoriteBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Like"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(favour)];
	
	self.navigationItem.rightBarButtonItems = @[shareBarButtonItem, favoriteBarButtonItem];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchStoreComments) name:ML_NOTIFICATION_IDENTIFIER_FETCH_STORE_COMMENTS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchStoreDetails) name:ML_NOTIFICATION_IDENTIFIER_FETCH_STORE_DETAILS object:nil];
	
//#warning TODO
//	_store = [[MLStore alloc] init];
//	_store.ID = @"CF2CEAAB-34D2-7660-61D5-1D6AE3D9D9E1";
//	NSLog(@"store id: %@", _store.ID);
	
	[self fetchStoreDetails];
	[self fetchStoreComments];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ML_NOTIFICATION_IDENTIFIER_FETCH_STORE_COMMENTS object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ML_NOTIFICATION_IDENTIFIER_FETCH_STORE_DETAILS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchStoreDetails {
	[[MLAPIClient shared] storeDetails:_store.ID withBlock:^(NSDictionary *attributes, NSError *error) {
		if (!error) {
			_store = [[MLStore alloc] initWithAttributes:attributes];
			[_tableView reloadData];
		}
	}];
}

- (void)fetchStoreComments {
	[[MLAPIClient shared] storeComments:_store.ID page:@(1) withBlock:^(NSNumber *highOpinion, NSNumber *commentsNumber, NSArray *multiAttributes, NSError *error) {
		if (!error) {
			_storeComments = [MLStoreComment multiWithAttributesArray:multiAttributes];
			[_tableView reloadData];
		}
	}];
}

- (void)share {
	if (_sharing) return;
	_sharing = YES;
	[[MLAPIClient shared] shareWithObject:MLShareObjectEStore platform:MLSharePlatformQQ objectID:_store.ID withBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			MLShare *share = [[MLShare alloc] initWithAttributes:attributes];
			[UMSocialSnsService presentSnsIconSheetView:self appKey:ML_UMENG_APP_KEY shareText:share.word shareImage:[UIImage imageNamed:@"MoliIcon"] shareToSnsNames:@[UMShareToSina, UMShareToQzone, UMShareToQQ, UMShareToWechatTimeline, UMShareToWechatSession] delegate:self];
		}
	}];
}

#pragma mark - UMSocialUIDelegate

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
	_sharing = NO;
}


- (void)favour {
	[[MLAPIClient shared] store:_store favour:YES withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
	}];
}

- (void)comment {
	MLStoreCommentViewController *storeCommentViewController = [[MLStoreCommentViewController alloc] initWithNibName:nil bundle:nil];
	storeCommentViewController.store = _store;
	storeCommentViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:storeCommentViewController animated:YES];
}

#pragma mark - MLStoreDetailsTableViewCellDelegate

- (void)storeDetailsTableViewCellWillCall:(MLStore *)store {
	if (!_store.phones.count) {
		[self displayHUDTitle:nil message:NSLocalizedString(@"暂无联系方式", nil) duration:1];
		return;
	}
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:nil];
	for (id phone in _store.phones) {
		[actionSheet addButtonWithTitle:phone];
	}
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)storeDetailsTableViewCellWillMap:(MLStore *)store {
#warning TODO
//    MLMapViewController *mapViewController = [MLMapViewController new];
//    mapViewController.store = store;
//    mapViewController.city = _city;
//    [self.navigationController pushViewController:mapViewController animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex || buttonIndex == actionSheet.destructiveButtonIndex) {
		return;
	}
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _store.phones[buttonIndex]]]];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 2) {
		UIView *view = [[UIView alloc] init];
		view.backgroundColor = [UIColor	whiteColor];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.separatorInset.left, 10, tableView.frame.size.width - 2 * tableView.separatorInset.left, 20)];
		label.text = NSLocalizedString(@"用户评价", nil);
		label.textColor = [UIColor lightGrayColor];
		[view addSubview:label];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(tableView.frame.size.width - 15 - 40, 10, 40, 20);
		[button addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Commit"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"CommitHighlighted"] forState:UIControlStateHighlighted];
		[view addSubview:button];
		return view;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 2) {
		return 40;
	}
	return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 1) {
		return 10;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	return [class height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _sectionClasses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 2) {
		return _storeComments.count;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Class class = _sectionClasses[indexPath.section];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[class identifier]];
	if (!cell) {
		cell = [[class alloc] initWithStyle:[class style] reuseIdentifier:[class identifier]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	if (indexPath.section == 0) {
		MLStoreDetailsTableViewCell *detailsCell = (MLStoreDetailsTableViewCell *)cell;
		detailsCell.delegate = self;
		detailsCell.store = _store;
	}
	if (indexPath.section == 2) {
		MLStoreComment *storeComment = _storeComments[indexPath.row];
		MLStoreCommentTableViewCell *commentCell = (MLStoreCommentTableViewCell *)cell;
		commentCell.storeComment = storeComment;
	}
	return cell;
}



@end
