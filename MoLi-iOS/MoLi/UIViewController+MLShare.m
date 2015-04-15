//
//  UIViewController+MLShare.m
//  MoLi
//
//  Created by zhangbin on 4/15/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "UIViewController+MLShare.h"
#import "Header.h"

static MLShareObject _shareObject = MLShareObjectAPP;
static MLSharePlatform _platform = MLSharePlatformWeibo;
static NSString *_objectID = nil;

@implementation UIViewController (MLShare)

- (void)socialShare:(MLShareObject)shareObject objectID:(NSString *)objectID {
	_shareObject = shareObject;
	_objectID = objectID;
	
	[[MLAPIClient shared] shareWithObject:_shareObject platform:_platform objectID:_objectID withBlock:^(NSDictionary *attributes, MLResponse *response) {
		[self displayResponseMessage:response];
		if (response.success) {
			MLShare *share = [[MLShare alloc] initWithAttributes:attributes];
            UIImage *image = [UIImage imageNamed:@"Icon60"];
			[UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:ML_UMENG_APP_KEY
                                              shareText:share.word
                                             shareImage:image
                                        shareToSnsNames:@[UMShareToSina, UMShareToQzone, UMShareToQQ, UMShareToWechatTimeline, UMShareToWechatSession]
                                               delegate:self];
		}
	}];
}

- (MLSharePlatform)platfrom:(NSString *)platformName {
	if ([platformName isEqualToString:UMShareToQzone]) {
		return MLSharePlatformQZone;
	} else if ([platformName isEqualToString:UMShareToQQ]) {
		return MLSharePlatformQQ;
	} else if ([platformName isEqualToString:UMShareToWechatTimeline]) {
		return MLSharePlatformWeChatCircle;
	} else if ([platformName isEqualToString:UMShareToWechatSession]) {
		return MLSharePlatformWeChatMessage;
	}
	return MLSharePlatformWeibo;
}

#pragma mark - UMSocialUIDelegate

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
	_platform = [self platfrom:platformName];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
	[[MLAPIClient shared] shareCallbackWithObject:_shareObject platform:_platform objectID:_objectID withBlock:^(MLResponse *response) {
		[self displayResponseMessage:response];
	}];
}

#pragma mark - UMSocialDataDelegate

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response {
}

@end
