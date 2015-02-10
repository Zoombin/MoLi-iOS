//
//  MLMessagesViewController.m
//  MoLi
//
//  Created by zhangbin on 12/15/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLMessagesViewController.h"
#import "Header.h"
#import "MLMessage.h"
#import "MLMessageDetailsViewController.h"
#import "MLNoDataView.h"
#import "MLMessageTableViewCell.h"

@interface MLMessagesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *messages;
@property (readwrite) MLNoDataView *noDataView;

@end

@implementation MLMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.title = NSLocalizedString(@"我的消息", nil);
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.tableFooterView = [[UIView alloc] init];
	_tableView.separatorInset = UIEdgeInsetsZero;
	[self.view addSubview:_tableView];
	
	_noDataView = [[MLNoDataView alloc] initWithFrame:self.view.bounds];
	_noDataView.imageView.image = [UIImage imageNamed:@"NoMessage"];
	_noDataView.label.text = @"您还没有消息";
	[self.view addSubview:_noDataView];
	
	[self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
	[self displayHUD:NSLocalizedString(@"加载中...", nil)];
	[[MLAPIClient shared] messagesWithPage:@(1) withBlock:^(NSArray *multiAttributes, MLResponse *response) {
		if (response.message) {
			[self displayHUDTitle:nil message:response.message];
		} else {
			[self hideHUD:YES];
		}
		if (response.success) {
			_messages = [MLMessage multiWithAttributesArray:multiAttributes];
			_noDataView.hidden = _messages.count ? YES : NO;
			[_tableView reloadData];
		}
	}];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [MLMessageTableViewCell height];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MLMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[MLMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MLMessageTableViewCell identifier]];
	}
	MLMessage *message = _messages[indexPath.row];
	cell.message = message;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	MLMessageDetailsViewController *messageDetailsViewController = [[MLMessageDetailsViewController alloc] initWithNibName:nil bundle:nil];
	MLMessage *message = _messages[indexPath.row];
	messageDetailsViewController.message = message;
	[self.navigationController pushViewController:messageDetailsViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self displayHUD:@"加载中..."];
		MLMessage *message = _messages[indexPath.row];
		[[MLAPIClient shared] deleteMessage:message withBlock:^(MLResponse *response) {
			if (response.message) {
				[self displayHUDTitle:nil message:response.message];
			}
			if (response.success) {
				[self loadData];
			}
		}];
	}
}

@end
