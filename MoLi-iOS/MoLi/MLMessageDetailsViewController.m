//
//  MLMessageDetailsViewController.m
//  MoLi
//
//  Created by zhangbin on 12/16/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLMessageDetailsViewController.h"
#import "Header.h"
#import "FMDBManger.h"
@interface MLMessageDetailsViewController ()

@property (readwrite) UIScrollView *scrollView;
@property (readwrite) UITextView *textView;

@end

@implementation MLMessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = _message.title;
	[self setLeftBarButtonItemAsBackArrowButton];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:_scrollView];

	_textView = [[UITextView alloc] initWithFrame:CGRectMake(ML_COMMON_EDGE_LEFT, 10, self.view.frame.size.width - ML_COMMON_EDGE_LEFT - ML_COMMON_EDGE_RIGHT, self.view.frame.size.height - 10)];
	_textView.font = [UIFont systemFontOfSize:16];
	_textView.editable = NO;
	[_scrollView addSubview:_textView];
	
	[self displayHUD:@"加载中..."];
	[[MLAPIClient shared] detailsOfMessage:_message withBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];		
		if (response.success) {
            _message.isRead = @1;//标为已读信息
            [[FMDBManger shared] operationMessage:_message updateMessage:YES delete:NO];
            int numofunmessage = [[[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_UNREADMESSAGECOUNT] intValue];
            numofunmessage--;
            if (numofunmessage<0) {
                numofunmessage = 0;
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:numofunmessage] forKey:ML_USER_UNREADMESSAGECOUNT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            /*
            [[MLAPIClient shared] ReadOfMessage:_message withBlock:^(NSDictionary *attributes, MLResponse *response) {
                if (response.success) {
                    [[FMDBManger shared] operationMessage:_message updateMessage:YES delete:NO];
                    int numofunmessage = [[[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_UNREADMESSAGECOUNT] intValue];
                    numofunmessage--;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:numofunmessage] forKey:ML_USER_UNREADMESSAGECOUNT];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
            }];
             */
			_message = [[MLMessage alloc] initWithAttributes:attributes];
			_textView.text = _message.content;
			[_textView sizeToFit];
			
			
			CGRect rect = CGRectMake(CGRectGetMinX(_textView.frame) + 5, CGRectGetMaxY(_textView.frame), self.view.bounds.size.width, 0.5);
			
			[_scrollView addSubview:[UIView borderLineWithFrame:rect]];
			UIImage *image = [UIImage imageNamed:@"Date"];
			rect.size = image.size;
			rect.origin.y = CGRectGetMaxY(_textView.frame) + 10;
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
			imageView.image = image;
			[_scrollView addSubview:imageView];
			
			rect.origin.x = CGRectGetMaxX(imageView.frame) + 5;
			rect.size.width = self.view.bounds.size.width - rect.origin.x;
			UILabel *dateLabel = [[UILabel alloc] initWithFrame:rect];
			dateLabel.text = [_message displaySendDate];
			dateLabel.font = [UIFont systemFontOfSize:13];
			dateLabel.textColor = [UIColor fontGrayColor];
			[_scrollView addSubview:dateLabel];
			
			_scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, CGRectGetMaxY(dateLabel.frame));
		}
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
