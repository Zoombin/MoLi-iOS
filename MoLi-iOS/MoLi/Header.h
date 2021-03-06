//
//  Header.h
//  MoLi
//
//  Created by zhangbin on 12/18/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

//Manager
#import "MLAPIClient.h"
#import "MLLocationManager.h"
#import "MLResponse.h"
#import "MLGlobal.h"

//Categories
#import "AppDelegate+ML.h"
#import "UIColor+ML.h"
#import "UIImageView+AFNetworking.h"
#import	"UIViewController+HUD.h"
#import "UIImage+LogN.h"
#import "UIColor+Random.h"
#import "UITableViewCell+ZBUtilities.h"
#import "UIImage+ML.h"
#import "UICollectionViewCell+ZBUtilites.h"
#import "UIColor+Hex.h"
#import "NSString+Hex.h"
#import "UIActionSheet+ZBUtilities.h"
#import "UIViewController+ImagePicker.h"
#import "UIViewController+ZBUtilites.h"
#import "UIViewController+ML.h"
#import "NSString+ZBUtilites.h"
#import "UITextField+SameStyle.h"
#import "UILabel+SameStyle.h"
#import "UIView+SameStyle.h"
#import "UIView+ML.h"
#import "NSNumber+ML.h"
#import "UIView+ZBUtilites.h"
#import "UIAlertView+ML.h"
#import "UIScrollView+ML.h"
#import "UIView+DashLine.h"
#import "UIViewController+MLShare.h"
#import "NSError+ML.h"

//umeng share
#import "UMSocial.h"

extern NSString * const ML_UMENG_APP_KEY;

extern CGFloat const ML_COMMON_EDGE_LEFT;
extern CGFloat const ML_COMMON_EDGE_RIGHT;
extern NSString * const ML_GOODS_PROPERTIES_PICKER_VIEW_STYLE_KEY;

//Notification
extern NSString * const ML_NOTIFICATION_IDENTIFIER_FETCH_STORE_COMMENTS;
extern NSString * const ML_NOTIFICATION_IDENTIFIER_FETCH_STORE_DETAILS;
extern NSString * const ML_NOTIFICATION_IDENTIFIER_SYNC_CART;
extern NSString * const ML_NOTIFICATION_IDENTIFIER_CLOSE_GOODS_PROPERTIES;
extern NSString * const ML_NOTIFICATION_IDENTIFIER_OPEN_GOODS_PROPERTIES;
extern NSString * const ML_NOTIFICATION_IDENTIFIER_OPEN_ORDERS;
extern NSString * const ML_NOTIFICATION_IDENTIFIER_SIGNOUT;
extern NSString * const ML_NOTIFICATION_IDENTIFIER_ADD_GOODS_TO_CART_SUCCEED;
extern NSString * const ML_NOTIFICATION_IDENTIFIER_RED_DOT;
extern NSString * const ML_NOTIFICATION_IDENTIFIER_REFRESH_ORDER_DETAILS;

//User defaults
extern NSString * const ML_USER_DEFAULT_IDENTIFIER_DISPLAYED_GUIDE;
extern NSString * const ML_USER_DEFAULT_IDENTIFIER_NEXT_VERIFYCODE_TIMESTAMP;
extern NSString * const ML_USER_DEFAULT_IDENTIFIER_SEARCH_GOODS_HISTORY;
extern NSString * const ML_USER_DEFAULT_IDENTIFIER_SEARCH_STORES_HISTORY;
extern NSString * const ML_USER_DEFAULT_IDENTIFIER_NETWORKING;
extern NSString * const ML_USER_DEFAULT_IDENTIFIER_PUSH;
extern NSString * const ML_USER_DEFAULT_IDENTIFIER_PUSH_SOUND;
extern NSString * const ML_USER_DEFAULT_NETWORKING_VALUE_AUTO;
extern NSString * const ML_USER_DEFAULT_NETWORKING_VALUE_WIFI;
extern NSString * const ML_USER_DEFAULT_NETWORKING_VALUE_3G;
extern NSString * const ML_USER_DEFAULT_PUSH_NONE_VALUE;
extern NSString * const ML_USER_DEFAULT_PUSH_VALUE;
extern NSString * const ML_USER_DEFAULT_PUSH_SOUND_VALUE;
extern NSString * const ML_USER_DEFAULT_IDENTIFIER_ACCOUNT;
extern NSString * const ML_USER_DEFAULT_MAIN_VIEW_CONTROLLER_DATA_KEY;
extern NSString * const ML_USER_DEFAULT_MAIN_VIEW_CONTROLLER_DATA_STYLE;
extern NSString * const ML_USER_DEFAULT_NEW_GOODS_COUNT_ADDED_TO_CART;
extern NSString * const ML_USER_NEWMESSAGETIME;
extern NSString * const ML_USER_NEWMESSAGELISTTIME;
extern NSString * const ML_GOODS_TAKE;
extern NSString * const ML_USER_UNREADMESSAGECOUNT;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
