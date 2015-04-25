//
//  MLAPIClient.m
//  MoLi
//
//  Created by zhangbin on 11/17/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLAPIClient.h"
#import "AFNetworkReachabilityManager.h"
#import "MLSecurity.h"
#import "IPAddress.h"
#import "MLTicket.h"
#import "CocoaSecurity.h"
#import "MLUser.h"
#import "MLLocationManager.h"
#import "Header.h"
#import "Base64.h"

@implementation MLAPIClient

+ (instancetype)shared {
	static MLAPIClient *_shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSString *baseURLString = @"http://appdev.imooly.com:8088/moolyapp/api/v1.0/";//开发
//        NSString *baseURLString = @"http://222.92.197.76/MoolyApp/";//测试
		NSURL *url = [NSURL URLWithString:baseURLString];
		_shared = [[MLAPIClient alloc] initWithBaseURL:url];
		NSMutableSet *types = [_shared.responseSerializer.acceptableContentTypes mutableCopy];
		[types addObject:@"image/png"];
		_shared.responseSerializer.acceptableContentTypes = types;
		_shared.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
	});
	return _shared;

}

- (BOOL)sessionValid {
    MLUser *me = [MLUser unarchive];
    return (me.phone.length && me.sessionID.length) ? YES : NO;
}

- (void)makeSessionInvalid {
    MLUser *me = [MLUser unarchive];
    if (me) {
        [me destroy];
    }
}

- (NSString *)userAccount {
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_IDENTIFIER_ACCOUNT];
    return account;
}

- (void)saveUserAccount:(NSString *)account {
    if (account.length) {
        [[NSUserDefaults standardUserDefaults] setObject:account forKey:ML_USER_DEFAULT_IDENTIFIER_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)removeUserAccount {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ML_USER_DEFAULT_IDENTIFIER_ACCOUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString	*)appVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)network {
    NSString *setting = [[NSUserDefaults standardUserDefaults] objectForKey:ML_USER_DEFAULT_IDENTIFIER_NETWORKING];
    if (setting) {
        if (![setting.uppercaseString isEqualToString:ML_USER_DEFAULT_NETWORKING_VALUE_AUTO]) {
            return setting;
        }
    }
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        return @"WIFI";
    }
    return @"3G";
}

- (void)parameters:(NSMutableDictionary *)parameters addLocation:(CLLocation *)location {
    if (!location || !parameters) return;
    parameters[@"lng"] = @(location.coordinate.longitude);
    parameters[@"lat"] = @(location.coordinate.latitude);
}

- (NSString *)signatureWithSecurity:(MLSecurity *)security ticket:(MLTicket *)ticket timestamp:(NSUInteger)timestamp {
    NSArray *array = @[security.appID, security.appSecret, ticket.ticket, [@(timestamp) stringValue]];
    NSArray *sorted = [array sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *sortedString = [@"" mutableCopy];
    for (NSString *s in sorted) {
        [sortedString appendString:s];
    }
    CocoaSecurityResult *result = [CocoaSecurity md5:sortedString];
    return result.hexLower;
}

- (NSDictionary *)dictionaryWithCommonParameters {
    MLSecurity *security = [MLSecurity unarchive];
    MLTicket *ticket = [MLTicket unarchive];
    if (!security || !ticket) {
        return @{};
    }
    NSAssert(security && ticket, @"security or ticket is nil");
    NSDate *date = [NSDate date];
    NSUInteger timestamp = (NSInteger)[date timeIntervalSince1970];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"appid"] = security.appID;
    parameters[@"signature"] = [self signatureWithSecurity:security ticket:ticket timestamp:timestamp];
    parameters[@"timestamp"] = @(timestamp);
    parameters[@"sessionid"] = ticket.sessionID;
    parameters[@"network"] = [self network];
    parameters[@"ip"] = [IPAddress currentIPAddress];
    parameters[@"deviceos"] = @"iOS";
    CLLocation *location = [MLLocationManager shared].currentLocation;
    [self parameters:parameters addLocation:location];
    return parameters;
}

- (NSError *)handleResponse:(id)responseObject {
    NSError *error = nil;
    NSNumber *flag = [responseObject valueForKeyPath:@"error"];
    if (flag.integerValue != 0) {
        NSString *message = [responseObject valueForKeyPath:@"msg"];
        if (!message || [message isEqual:[NSNull null]]) {
            message = NSLocalizedString(@"未知错误", nil);
        }
        error = [NSError errorWithDomain:@"ML_ERROR_DOMAIN" code:1 userInfo:@{@"ML_ERROR_MESSAGE_IDENTIFIER" : message}];
    }
    return error;
}

- (void)checkTicketWithBlock:(void (^)(BOOL valid, NSError *error))block {
    if ([MLTicket valid]) {
        if (block) block(YES, nil);
    } else {
        [self ticketWithBlock:^(NSDictionary *attributes, NSError *error) {
            if (!error) {
                MLTicket *ticket = [[MLTicket alloc] initWithAttributes:attributes];
                [ticket setDate:[NSDate date]];
                [ticket archive];
                if (block) block(YES, nil);
            } else {
                if (block) block(NO, error);
            }
        }];
    }
}

- (void)appRegister:(CLLocation *)location withBlock:(void (^)(NSDictionary *attributes, NSError *error))block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"deviceos"] = @"iOS";
    parameters[@"devicetype"] = [[UIDevice currentDevice] model];
    parameters[@"deviceosversion"] = [[UIDevice currentDevice] systemVersion];
    parameters[@"deviceid"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    parameters[@"appversion"] = [self appVersion];
    [self parameters:parameters addLocation:location];
    
    [self POST:@"apps/appregist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = [self handleResponse:responseObject];
        NSDictionary *attributes = nil;
        if (!error) {
            attributes = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"]];
        }
        if (block) block(attributes, error);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (void)ticketWithBlock:(void (^)(NSDictionary *attributes, NSError *error))block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    MLSecurity *security = [MLSecurity unarchive];
    parameters[@"appid"] = security && ![security.appID isNullString] ? security.appID : @"";
    
    [self GET:@"apps/getticket" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = [self handleResponse:responseObject];
        NSDictionary *attributes = nil;
		NSLog(@"get ticket: %@", responseObject);
        if (!error) {
            attributes = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"]];
        }
        if (block) block(attributes, error);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (void)checkVersionWithBlock:(void (^)(NSDictionary *attributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"devicetype"] = [[UIDevice currentDevice] model];
    parameters[@"version"] = [self appVersion];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"apps/newversion" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSDictionary *attributes = nil;
                if (!error) {
                    attributes = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"]];
                }
                if (block) block(attributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)fetchVervifyCode:(MLVerifyCode *)verifyCode withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"action"] = [verifyCode identifier];
    parameters[@"phone"] = verifyCode.mobile;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/sendvcode" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)checkVervifyCode:(MLVerifyCode *)verifyCode withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"action"] = [verifyCode identifier];
    parameters[@"phone"] = verifyCode.mobile;
    parameters[@"vcode"] = verifyCode.code;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/ckvcode" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

#pragma mark - Goods

- (void)goodsClassifiesWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"lastpulltime"] = @(0);//TODO
    
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"goods/goodsclassifylist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSArray *multiAttributes = nil;
                if (!error) {
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"classifylist"]];
                }
                if (block) block(multiAttributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }
    }];
}

- (void)searchGoodsWithClassifyID:(NSString *)classifyID keywords:(NSString *)keywords price:(NSString *)price spec:(NSString *)spec orderby:(NSString *)orderby ascended:(BOOL)ascended stockflag:(int)sflag voucherflag:(int)vflag page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSError *error,NSDictionary *attributes))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    if (classifyID) parameters[@"classifyid"] = classifyID;
    if (keywords) parameters[@"keywords"] = keywords;
    if (price) parameters[@"price"] = price;
    if (spec) parameters[@"spec"] = spec;
    if (orderby) parameters[@"orderby"] = orderby;
    parameters[@"orderway"] = ascended ? @(0) : @(1);
    if (page) parameters[@"page"] = page;
    parameters[@"stockflag"] = [NSNumber numberWithInt:sflag];
    parameters[@"voucherflag"] = [NSNumber numberWithInt:vflag];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"goods/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSArray *multiAttributes = nil;
                NSDictionary *attributes =  nil;
                if (!error) {
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"goodslist"]];
                    attributes = [responseObject valueForKeyPath:@"data"];
                }
                if (block) block(multiAttributes, error,attributes);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error,nil);
            }];
        }
    }];
}

- (void)goodsDetails:(NSString *)goodsID withBlock:(void (^)(NSDictionary *attributes, NSArray *multiAttributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"goodsid"] = goodsID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"goods/profile" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                NSArray *multiAttributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = response.data;
                    multiAttributes = response.data[@"goodsrand"];
                }
                if (block) block(attributes, multiAttributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, nil);
            }];
        }
    }];
}


- (void)goodsComments:(NSString *)goodsId commentFlag:(NSString *)flag currentPage:(int)page withBlock:(void (^)(MLResponse * response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"goodsid"] = goodsId;
    parameters[@"commentflag"] = flag;
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    parameters[@"pagesize"] = @"10";
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"goods/commentlist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }
    }];
}


- (void)goodsProperties:(NSString *)goodsID withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"goodsid"] = goodsID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"goods/goodsspec" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSArray *multiAttributes = nil;
                if (!error) {
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"goodsspec"]];
                }
                if (block) block(multiAttributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)goodsImagesDetails:(NSString *)goodsID withBlock:(void (^)(NSDictionary *attributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"goodsid"] = goodsID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"goods/goodscontent" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSDictionary *attributes = nil;
                if (!error) {
                    attributes = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"]];
                }
                if (block) block(attributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)goods:(NSString *)goodsID favour:(BOOL)favorite withBlock:(void (^)(NSString *message, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    
    
    NSString *APIPath = @"user/addfavgoods";
    if (!favorite) {
        APIPath = @"user/delfavgoods";
        parameters[@"goodsids"] = [NSString stringWithFormat:@"[\"%@\"]", goodsID];
    } else {
        parameters[@"goodsid"] = goodsID;
    }
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:APIPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *message = nil;
                NSError *error = [self handleResponse:responseObject];
                if (!error) {
                    message = responseObject[@"data"][@"message"];
                }
                if (block) block(message, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)searchHotwordsForGoods:(BOOL)goodsOrStore withBlock:(void (^)(NSArray *words, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    
    NSString *APIPath = @"business/hotkeywords";
    if (goodsOrStore) {
        APIPath = @"goods/hotkeywords";
    }
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:APIPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *words = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    words = response.data[@"keywords"];
                }
                if (block) block(words, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)searchStoresWithCityID:(NSNumber *)cityID classifyID:(NSString *)classifyID circleID:(NSString *)circleID distance:(NSNumber *)distance keyword:(NSString *)keyword sort:(MLSortType)sortType page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    if (cityID) parameters[@"cityid"] = cityID;
    if (classifyID) parameters[@"classifyid"] = classifyID;
    if (circleID) parameters[@"circleid"] = circleID;
    if (distance) parameters[@"distance"] = distance;
    if (keyword) parameters[@"keywords"] = keyword;
    if (sortType == MLSortTypeDistance) {
        parameters[@"sort"] = @(1);
    } else if (sortType == MLSortTypeTime) {
        parameters[@"sort"] = @(2);
    }
    parameters[@"page"] = page;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"business/businesssearch" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *multiAttributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    multiAttributes = response.data[@"businesslist"];
                }
                if (block) block(multiAttributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)multiGoods:(NSArray *)multiGoodsIDs defavourWithBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    NSData *data = [NSJSONSerialization dataWithJSONObject:multiGoodsIDs options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    parameters[@"goodsids"] = json;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/delfavgoods" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)priceForGoods:(MLGoods *)goods selectedProperties:(NSString *)selectedPropertiesString withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"goodsid"] = goods.ID;
    parameters[@"goodsspec"] = selectedPropertiesString;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"goods/goodsprice" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response.data, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)vouchertermDetailwithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block
{
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    parameters[@"lastpulltime"] = [NSString stringWithFormat:@"%.f",interval];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"public/voucherterm" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response.data, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

#pragma mark - Store

- (void)citiesWithBlock:(void (^)(NSDictionary *attributes, NSArray *multiAttributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"business/storecitylist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSDictionary *attributes = nil;
                NSArray *multiAttributes = nil;
                if (!error) {
                    attributes = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"][@"current"]];
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"citylist"]];
                }
                if (block) block(attributes, multiAttributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, error);
            }];
        }}];
}

- (void)storesWithCityID:(NSNumber *)cityID hot:(BOOL)hot withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"cityid"] = cityID;
    
    NSString *APIPath = @"business/storerand";
    if (hot) APIPath = @"business/storehot";
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:APIPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSArray *multiAttributes = nil;
                if (!error) {
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"storelist"]];
                }
                if (block) block(multiAttributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)storeDetails:(NSString *)storeID withBlock:(void (^)(NSDictionary *attributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"businessid"] = storeID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"business/discountstore" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSDictionary *attributes = nil;
                if (!error) {
                    attributes = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"]];
                }
                if (block) block(attributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)storeComments:(NSString *)storeID page:(NSNumber *)page withBlock:(void (^)(NSNumber *highOpinion, NSNumber *commentsNumber, NSArray *multiAttributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"businessid"] = storeID;
    parameters[@"page"] = page;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"business/commentlist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSNumber *highOpinion = nil;
                NSNumber *commentsNumber = nil;
                NSArray *multiAttributes = nil;
                if (!error) {
                    highOpinion = [responseObject valueForKeyPath:@"data"][@"highopinion"];
                    commentsNumber = [responseObject valueForKeyPath:@"data"][@"totalcomment"];
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"commentlist"]];
                }
                if (block) block(highOpinion, commentsNumber, multiAttributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, nil, error);
            }];
        }}];
}

- (void)submitCommentOfStore:(NSString *)storeID star:(NSNumber *)star content:(NSString *)content withBlock:(void (^)(NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"businessid"] = storeID;
    MLUser *me = [MLUser unarchive];
    if (me) parameters[@"uid"] = me.userID;
    parameters[@"star"] = star;
    parameters[@"content"] = content;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"business/comment" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                if (block) block(error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(error);
            }];
        }}];
}

- (void)storeClassifiesWithBlock:(void (^)(NSArray *multiAttribues, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"business/businessclassifylist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *multiAttributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    multiAttributes = response.data[@"classifylist"];
                }
                if (block) block(multiAttributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)storeCirclesWithBlock:(void(^)(NSArray *distances, NSArray *multiAttributtes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"business/circlelist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *distances = nil;
                NSArray *multiAttributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    distances = response.data[@"near"];
                    multiAttributes = response.data[@"arealist"];
                }
                if (block) block(distances, multiAttributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, nil);
            }];
        }}];
}

- (void)store:(MLStore *)store favour:(BOOL)favour withBlock:(void (^)(MLResponse *))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"businessid"] = store.ID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/addfavbusiness" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)stores:(NSArray *)storeIDs defavourWithBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    NSData *data = [NSJSONSerialization dataWithJSONObject:storeIDs options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    parameters[@"businessids"] = json;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/delfavbusiness" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)detailsOfFlagshipStoreID:(NSString *)flagshipStoreID withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"businessid"] = flagshipStoreID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"business/storeprofile" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)multiGoodsInFlagshipStoreID:(NSString *)flagshipStoreID page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"businessid"] = flagshipStoreID;
    if (page) parameters[@"page"] = page;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"goods/storegoodslist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *multiAttributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    multiAttributes = response.data[@"goodslist"];
                }
                if (block) block(multiAttributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)favourFlagshipStoreID:(NSString *)flagshipStoreID withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"storeid"] = flagshipStoreID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/addfavstore" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}


#pragma mark - Cart

- (void)addCartWithGoods:(NSString *)goodsID properties:(NSString *)properties number:(NSNumber *)number withBlock:(void (^)(MLResponse *response, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"goodsid"] = goodsID;
	if (!properties.length) {//商品没有属性传0
		parameters[@"spec"] = @"0";
	} else {
		parameters[@"spec"] = properties;
	}
    parameters[@"num"] = number;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"cart/add" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
				MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)syncCartWithPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSNumber *total, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"lastsynctime"] = @(0);
	parameters[@"pagesize"] = @(100);
    parameters[@"page"] = page;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"cart/sync" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSArray *multiAttributes = nil;
                NSNumber *total = nil;
                if (!error) {
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"goodslist"]];
                    total = [[responseObject valueForKeyPath:@"data"][@"totalnum"] notNull];
                }
                if (block) block(multiAttributes, total, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, error);
            }];
        }}];
}

- (void)deleteMultiGoods:(NSArray *)multiGoods withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    NSArray *array = [MLGoods handleMultiGoodsWillDeleteOrUpdate:multiGoods];
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    parameters[@"goodslist"] = json;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"cart/delete" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)updateMultiGoods:(NSArray *)multiGoods withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    NSArray *array = [MLGoods handleMultiGoodsWillDeleteOrUpdate:multiGoods];
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    parameters[@"goodslist"] = json;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"cart/update" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

#pragma mark - signin, signup

- (void)signinWithAccount:(NSString *)account password:(NSString *)password withBlock:(void (^)(NSDictionary *attributes, MLResponse *response, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"phone"] = account;
    CocoaSecurityResult *md5Password = [CocoaSecurity md5:password];
    MLTicket *ticket = [MLTicket unarchive];
    CocoaSecurityResult *md5 = [CocoaSecurity md5:[NSString stringWithFormat:@"%@%@", md5Password.hexLower, ticket.ticket]];
    parameters[@"password"] = md5.hexLower;
	[self POST:@"user/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
		if (response.success) {
			[self saveUserAccount:account];
		}
		if (block) block(response.data, response, nil);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(nil, nil, error);
	}];
}

- (void)autoSigninWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response, NSError *error))block {
    NSAssert([self sessionValid], @"Session invalid.");
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    MLUser *me = [MLUser unarchive];
    parameters[@"phone"] = me.phone;
    parameters[@"signtoken"] = me.signToken;
	
	[self POST:@"user/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
		if (block) block(response.data, response, nil);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(nil, nil, error);
	}];
}

- (void)identifyWithVerifyCode:(MLVerifyCode *)verifyCode password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"phone"] = verifyCode.mobile;
    parameters[@"vcode"] = verifyCode.code;
    parameters[@"password"] = password;
    parameters[@"passwordc"] = passwordConfirm;
    
    NSString *APIPath = @"user/registcomplete";
    if (verifyCode.type == MLVerifyCodeTypeForgotPassword) {
        APIPath = @"user/forgotpwdnew";
    } else if (verifyCode.type == MLVerifyCodeTypeForgotWalletPassword) {
        APIPath = @"wallet/forgotuserwalletpwdnew";
    }
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:APIPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)fetchSignupTermsWithBlock:(void (^)(NSString *URLString, NSString *message, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/registterms" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *URLString = nil;
                NSString *message = nil;
                NSError *error = [self handleResponse:responseObject];
                if (!error) {
                    URLString = [responseObject valueForKeyPath:@"data"][@"linkaddress"];
                    message = [responseObject valueForKeyPath:@"data"][@"msg"];
                }
                if (block) block(URLString, message, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, error);
            }];
        }}];
}

- (void)changeOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword newPasswordConfirm:(NSString *)newPasswordConfirm withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"oldpassword"] = oldPassword;
    parameters[@"password"] = newPassword;
    parameters[@"passwordc"] = newPasswordConfirm;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/setuserpwd" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)signoutWithBlock:(void (^)(NSString *message, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/logout" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *message = nil;
                NSError *error = [self handleResponse:responseObject];
                if (!error) {
                    message = [responseObject valueForKeyPath:@"data"][@"msg"];
                }
                if (block) block(message, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)orderCommentInfo:(NSString *)orderNo WithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"orderno"] = orderNo;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"order/comment" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSDictionary *attributes = nil;
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)sendComment:(NSString *)orderNo commentInfo:(NSString *)commentInfo WithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"orderno"] = orderNo;
    parameters[@"commentlist"] = commentInfo;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"order/sendcomment" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSDictionary *attributes = nil;
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

#pragma mark - Me

- (void)myfavoritesSummaryWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/favinfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSDictionary *attributes = nil;
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
    
}

- (void)favoritesGoodsWithPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"page"] = page;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/favgoodslist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSArray *multiAttributes = nil;
                if (!error) {
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"goodslist"]];
                }
                if (block) block(multiAttributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)favoritesFlagshipStoreWithPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"page"] = page;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/favstorelist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSArray *multiAttributes = nil;
                if (!error) {
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"storelist"]];
                }
                if (block) block(multiAttributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)favoritesStoreWithPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"page"] = page;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/favbusinesslist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSArray *multiAttributes = nil;
                if (!error) {
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"businesslist"]];
                }
                if (block) block(multiAttributes, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)messagesWithPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"lastpulltime"] = @(0);//TODO
    parameters[@"page"] = page;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"message/newmsg" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSArray *multiAttributes = nil;
                if (response.success) {
                    multiAttributes = response.data[@"msglist"];
                }
                if (block) block(multiAttributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)memeberCardWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/onlinevipcard" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSDictionary *attributes = nil;
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)flagStores:(NSArray *)flagStoreIDs defavourWithBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    NSData *data = [NSJSONSerialization dataWithJSONObject:flagStoreIDs options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    parameters[@"storeids"] = json;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/delfavstore" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)numberOfNewMessagesWithBlock:(void (^)(NSNumber *number, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"message/cknewmsg" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSNumber *number = nil;
                if (response.success) {
                    number = response.data[@"num"];
                }
                if (block) block(number, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)detailsOfMessage:(MLMessage *)message withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"messageid"] = message.ID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"message/msginfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSDictionary *attributes = nil;
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)deleteMessage:(MLMessage *)message withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"messageid"] = message.ID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"message/deletemsg" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

#pragma mark - Address

- (void)addressesWithBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"lastpulltime"] = @(0);//TODO
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/addresslist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *multiAttributes = nil;
                NSString *message = nil;
                NSError *error = [self handleResponse:responseObject];
                if (!error) {
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"addresslist"]];
                    message = [responseObject valueForKeyPath:@"msg"];
                }
                if (block) block(multiAttributes, message, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, error);
            }];
        }}];
}

- (void)addAddress:(MLAddress *)address withBlock:(void (^)(NSString *message, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    if (address.provinceID) parameters[@"provinceid"] = address.provinceID;
    if (address.cityID) parameters[@"cityid"] = address.cityID;
    if (address.areaID) parameters[@"areaid"] = address.areaID;
    if (address.street) parameters[@"street"] = address.street;
    if (address.postcode) parameters[@"code"] = address.postcode;
    if (address.name) parameters[@"name"] = address.name;
//    if (address.phone) parameters[@"tel"] = address.phone;
    if (address.mobile) parameters[@"mobile"] = address.mobile;
    if (address.isDefault) parameters[@"isdefault"] = address.isDefault;
    
    NSString *APIPath = @"user/addaddress";
    if (address.ID) {
        APIPath = @"user/updateaddress";
        parameters[@"addressid"] = address.ID;
    }
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:APIPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *message = nil;
                NSError *error = [self handleResponse:responseObject];
                if (!error) {
                    message = [responseObject valueForKeyPath:@"msg"];
                }
                if (block) block(message, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)setDefaultAddress:(NSString *)addressID withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"addressid"] = addressID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/setdefaddress" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)deleteAddress:(NSString *)addressID withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"addressid"] = addressID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/deleteaddress" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)provincesWithBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"public/province" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *multiAttributes = nil;
                NSString *message = nil;
                NSError *error = [self handleResponse:responseObject];
                if (!error) {
                    multiAttributes = [responseObject valueForKeyPath:@"data"][@"province"];
                    message = [responseObject valueForKeyPath:@"msg"];
                }
                if (block) block(multiAttributes, message, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, error);
            }];
        }}];
}

- (void)areasInProvince:(NSNumber *)provinceID withBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"pid"] = provinceID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"public/city" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *multiAttributes = nil;
                NSString *message = nil;
                NSError *error = [self handleResponse:responseObject];
                if (!error) {
                    multiAttributes = [responseObject valueForKeyPath:@"data"][@"city"];
                    message = [responseObject valueForKeyPath:@"msg"];
                }
                if (block) block(multiAttributes, message, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, error);
            }];
        }}];
}

- (void)detailsOfAddress:(NSString *)addressID withBlock:(void (^)(NSDictionary *attributes, NSString *message, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"addressid"] = addressID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/addressinfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                NSString *message = nil;
                NSError *error = [self handleResponse:responseObject];
                if (!error) {
                    attributes = [responseObject valueForKeyPath:@"data"][@"addressinfo"];
                    message = [responseObject valueForKeyPath:@"msg"];
                }
                if (block) block(attributes, message, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, error);
            }];
        }}];
}

- (void)myVoucherWithBlock:(void (^)(NSNumber *voucherValue, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"wallet/myvoucher" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSNumber *voucherValue = nil;
                if (response.success) {
                    voucherValue = response.data[@"voucher"];
                }
                if (block) block(voucherValue, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)newVoucherPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"page"] = page;
    parameters[@"pagesize"] = @(999);
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"wallet/newvoucher" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSArray *multiAttributes = nil;
                if (response.success) {
                    multiAttributes = response.data[@"voucherlist"];
                }
                if (block) block(multiAttributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)takeVoucher:(MLVoucher *)voucher withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"orderno"] = voucher.orderNO;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"wallet/takevoucher" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)voucherFlowWithType:(MLVoucherFlowType)type page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"page"] = page;
#warning TODO
    parameters[@"pagesize"] = @(999);
    if (type == MLVoucherFlowTypeAll) {
        parameters[@"type"] = @"all";
    } else if (type == MLVoucherFlowTypeGet) {
        parameters[@"type"] = @"get";
    } else if (type == MLVoucherFlowTypeUse) {
        parameters[@"type"] = @"use";
    }
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"wallet/voucherflow" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *multiAttributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    multiAttributes = response.data[@"voucherflow"];
                }
                if (block) block(multiAttributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)voucherValueWillGet:(MLVoucher *)voucher withBlock:(void (^)(NSNumber *value, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"orderno"] = voucher.orderNO;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"wallet/voucheramount" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSNumber *value = nil;
                if (response.success) {
                    value = response.data[@"voucher"];
                }
                if (block) block(value, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

#pragma mark - Order

- (void)orders:(NSString *)status page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"page"] = page;
    parameters[@"status"] = status;
    parameters[@"pagesize"] = @(999);
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"order/orderlist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = [self handleResponse:responseObject];
                NSArray *multiAttributes = nil;
                NSString *message = nil;
                if (!error) {
                    multiAttributes = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"data"][@"orderlist"]];
                    message = [responseObject valueForKeyPath:@"data"][@"msg"];
                }
                if (block) block(multiAttributes, message, error);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, error);
            }];
        }}];
}

- (void)prepareOrder:(NSArray *)multiGoods buyNow:(BOOL)buyNow addressID:(NSString *)addressID withBlock:(void (^)(BOOL vip, NSDictionary *addressAttributes, NSDictionary *voucherAttributes, NSArray *multiGoodsWithError, NSArray *multiGoods, NSNumber *totalPrice, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    if (buyNow) {
        parameters[@"op"] = @"buynow";
    } else {
        parameters[@"op"] = @"buycart";
    }
    if (addressID) parameters[@"deaddressid"] = addressID;
    
    NSArray *array = [MLGoods handleMultiGoodsWillDeleteOrUpdate:multiGoods];
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    parameters[@"goods"] = json;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"order/make" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                BOOL vip = NO;
                NSDictionary *addressAttributes = nil;
                NSDictionary *voucherAttributes = nil;
                NSArray *multiGoodsWithError = nil;
                NSArray *multiGoods = nil;
                NSNumber *totalPrice = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    vip = [response.data[@"vipmember"] boolValue];
                    addressAttributes = [response.data[@"address"] notNull];
					
					NSString *voucherImage = [response.data[@"voucherimage"] notNull];
					NSNumber *voucher = [response.data[@"voucher"] notNull];
					NSNumber *totalVoucher = [response.data[@"totalvoucher"] notNull];
					if (voucherImage && voucher && totalVoucher) {
						voucherAttributes = @{@"voucherimage" : voucherImage,
											  @"voucher" : voucher,
											  @"totalvoucher" : totalVoucher
											  };
					}
					
                    multiGoodsWithError = response.data[@"goodserror"];
                    multiGoods = response.data[@"goodslist"];
                    totalPrice = response.data[@"totalprice"];
                }
                if (block) block(vip, addressAttributes, voucherAttributes, multiGoodsWithError, multiGoods, totalPrice, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(NO, nil, nil, nil, nil, nil, nil);
            }];
        }}];
    
}

- (void)saveOrder:(NSArray *)cartStores buyNow:(BOOL)buyNow address:(NSString *)addressID voucher:(MLVoucher *)voucher walletPassword:(NSString *)walletPassword withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    if (buyNow) {
        parameters[@"op"] = @"buynow";
    } else {
        parameters[@"op"] = @"buycart";
    }
    parameters[@"addressid"] = addressID;
    if (voucher) {
        if (voucher.voucherWillingUse) parameters[@"voucher"] = voucher.voucherWillingUse;
    }
    if (walletPassword) {
        CocoaSecurityResult *result = [CocoaSecurity md5:walletPassword];
        parameters[@"walletpwd"] = result.hexLower;
    }
    
    NSArray *array = [MLCartStore handleCartStoresForSaveOrder:cartStores];
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    parameters[@"goods"] = json;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"order/save" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"save order: %@", responseObject);
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = responseObject[@"data"];
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)cancelService:(NSString *)orderNo
              goodsId:(NSString *)goodsId
              tradeId:(NSString *)tradeId
                 type:(NSString *)type
            withBlock:(void (^)(NSDictionary *, MLResponse *))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"orderno"] = orderNo;
    parameters[@"goodsid"] = goodsId;
    parameters[@"tradeid"] = tradeId;
    parameters[@"type"] = type;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"order/servicecancel" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = responseObject[@"data"];
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}


- (void)operateOrder:(MLOrder *)order orderOperator:(MLOrderOperator *)orderOperator afterSalesGoods:(MLAfterSalesGoods *)afterSalesGoods password:(NSString *)password withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    if (order) {
        parameters[@"orderno"] = order.ID;
        parameters[@"type"] = @"normal";
        if (password) {
            CocoaSecurityResult *md5Password = [CocoaSecurity md5:password];
            parameters[@"walletpwd"] = md5Password.hexLower;
        }
    }
    
    if (afterSalesGoods) {
        parameters[@"orderno"] = afterSalesGoods.orderNO;
        parameters[@"goodsid"] = afterSalesGoods.goodsID;
        parameters[@"tradeid"] = afterSalesGoods.tradeID;
        parameters[@"type"] = afterSalesGoods.typeString ?: @"";
    }
    
    NSMutableString *APIPath = [NSMutableString stringWithString:@"order/"];
    [APIPath appendFormat:@"%@", [MLOrderOperator identifierForType:orderOperator.type]];
    
    NSString *methodName = [MLOrderOperator methodNameForType:orderOperator.type];
    if ([methodName isEqual:@"GET"]) {
        [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
            if (valid) {
                [self GET:APIPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *attributes = nil;
                    MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                    if (response.success) {
                        attributes = response.data;
                    }
                    if (block) block(attributes, response);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (block) block(nil, nil);
                }];
            }}];
    } else {
        [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
            if (valid) {
                [self POST:APIPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *attributes = nil;
                    MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                    if (response.success) {
                        attributes = response.data;
                    }
                    if (block) block(attributes, response);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (block) block(nil, nil);
                }];
            }}];
    }
}

- (void)myOrdersSummaryWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"order/myorder" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)orderProfile:(NSString *)orderNo
           withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"orderno"] = orderNo;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"order/profile" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)afterSalesGoodsChange:(BOOL)change page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"type"] = change ? @"change" : @"return";
    parameters[@"page"] = page;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"order/sgoodslist" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *multiAttributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    multiAttributes = response.data[@"goodslist"];
                }
                if (block) block(multiAttributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)afterSalesAdd:(MLAfterSalesGoods *)afterSalesGoods reason:(NSString *)reason imagePaths:(NSArray *)imagePaths addressID:(NSString *)addressID withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"orderno"] = afterSalesGoods.orderNO;
    parameters[@"goodsid"] = afterSalesGoods.goodsID;
    parameters[@"tradeid"] = afterSalesGoods.tradeID;
    parameters[@"type"] = afterSalesGoods.typeString;
    parameters[@"remark"] = reason;
    if (imagePaths.count) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:imagePaths options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        parameters[@"images"] = json;
    }
    if (addressID) parameters[@"addressid"] = addressID;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"order/serviceadd" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)fetchBussinessInfoForAfterSales:(MLAfterSalesGoods *)afterSalesGoods withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"orderno"] = afterSalesGoods.orderNO;
    parameters[@"goodsid"] = afterSalesGoods.goodsID;
    parameters[@"tradeid"] = afterSalesGoods.tradeID;
    parameters[@"unique"] = afterSalesGoods.unique;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"order/servicebusiness" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)afterSalesSaveLogistic:(MLAfterSalesGoods *)afterSalesGoods buyerName:(NSString *)buyerName buyerPhone:(NSString *)buyerPhone logisticCompany:(NSString *)logisticCompany logisitcNO:(NSString *)logisticNO remark:(NSString *)remark withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"orderno"] = afterSalesGoods.orderNO;
    parameters[@"goodsid"] = afterSalesGoods.goodsID;
    parameters[@"tradeid"] = afterSalesGoods.tradeID;
    parameters[@"type"] = afterSalesGoods.typeString;
    parameters[@"name"] = buyerName;
    parameters[@"phone"] = buyerPhone;
    parameters[@"logisticname"] = logisticCompany;
    parameters[@"logisticno"] = logisticNO;
    if (remark) parameters[@"remark"] = remark;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"order/servicelogistic" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)fetchAfterSalesDetailInfo:(MLAfterSalesGoods *)afterSalesGoods
                        withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"orderno"] = afterSalesGoods.orderNO;
    parameters[@"goodsid"] = afterSalesGoods.goodsID;
    parameters[@"unique"] = afterSalesGoods.unique;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"order/sgoodsprofile" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

#pragma mark - AD

- (void)advertisementsInStores:(BOOL)forStores withBlock:(void (^)(NSString *style, NSArray *multiAttributes, MLResponse *response, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    
    NSString *APIPath = @"advertise/indexads";
    if (forStores) {
        APIPath = @"advertise/shopads";
    }
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:APIPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *style = nil;
                NSArray *multiAttributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    style = response.data[@"tpl"];
                    multiAttributes = response.data[@"tplcontent"];
                }
                if (block) block(style, multiAttributes, response, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil, nil, error);
            }];
		} else {
			if (block) block(nil, nil, nil, error);
		}
	}];
}


#pragma mark - Share

- (void)shareWithObject:(MLShareObject)object platform:(MLSharePlatform)platform objectID:(id)objectID withBlock:(void(^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"object"] = [MLShare identifierForShareObject:object];
    parameters[@"platform"] = [MLShare identifierForSHarePlayform:platform];
    
    NSDictionary *dictionary = [MLShare parameterWithShareObject:object objectID:objectID];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    parameters[@"params"] = json;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"share/sinfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"]];
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)shareCallbackWithObject:(MLShareObject)object platform:(MLSharePlatform)platform objectID:(NSString *)objectID withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"object"] = [MLShare identifierForShareObject:object];
    parameters[@"platform"] = [MLShare identifierForSHarePlayform:platform];
    
    NSDictionary *dictionary = [MLShare parameterWithShareObject:object objectID:objectID];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    parameters[@"params"] = json;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"share/scallback" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject: %@", responseObject);
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

#pragma mark - User
- (void)userInfoWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/userinfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"]];
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)updateUserInfo:(MLUser *)user withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    if (user.avatarData) {
        parameters[@"avatar"] = [user.avatarData base64EncodedString];
    }
    if (user.nickname) parameters[@"nickname"] = user.nickname;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/setinfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)VIPFeeWithBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"user/getfeeinfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *multiAttributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    multiAttributes = response.data[@"feelist"];
                }
                if (block) block(multiAttributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (NSURL *)VIPProtocolUrl
{
    return [NSURL URLWithString:@"public/vipuserterms" relativeToURL:[MLAPIClient shared].baseURL]   ;
}

- (NSURL *)versiondescUrl
{
    return [NSURL URLWithString:@"public/versiondesc?deviceos=iOS" relativeToURL:[MLAPIClient shared].baseURL]   ;
}

- (void)preparePayVIP:(MLVIPFee *)VIPFee withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"type"] = VIPFee.type;
    parameters[@"times"] = VIPFee.duration;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"user/vpay" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)appsInfoWithBlock:(void (^)(NSDictionary *attributes, NSError *error))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"public/appsinfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *attributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    attributes = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"]];
                }
                if (block) block(attributes, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)nearByStoreList:(NSString *)cityId withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
{
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"cityid"] = cityId;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"business/storenear" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *multiAttributes = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    multiAttributes = response.data[@"storelist"];
                }
                if (block) block(multiAttributes, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, error);
            }];
        }}];
}

- (void)uploadImage:(UIImage *)image withBlock:(void (^)(NSString *imagePath, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    NSString *dataString = [imageData base64EncodedString];
    parameters[@"imgfile"] = dataString;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"org/uploadimg" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *imagePath = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    imagePath = response.data[@"imgpath"];
                }
                if (block) block(imagePath, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)fetchImageWithPath:(NSString *)path withBlock:(void (^)(UIImage *image))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSData *imageData = operation.responseData;
                UIImage *image = nil;
                if (imageData.length) {
                    image = [UIImage imageWithData:imageData];
                }
                if (block) block(image);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)userHasWalletPasswordWithBlock:(void (^)(NSNumber *hasWalletPassword, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:@"wallet/ckuserwalletpwd" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSNumber *hasWalletPassword = nil;
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (response.success) {
                    hasWalletPassword = response.data[@"flag"];
                }
                if (block) block(hasWalletPassword, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)updateWalletPassword:(NSString *)password passwordConfirm:(NSString *)passwordConfirm currentPassword:(NSString *)currentPassword withBlock:(void (^)(MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    if (currentPassword) parameters[@"oldpassword"] = currentPassword;
    parameters[@"password"] = password;
    parameters[@"passwordc"] = passwordConfirm;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"wallet/setuserwalletpwd" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                if (block) block(response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil);
            }];
        }}];
}

- (void)payOrders:(NSArray *)orderIDs withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    NSData *data = [NSJSONSerialization dataWithJSONObject:orderIDs options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    parameters[@"orderno"] = json;
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self POST:@"order/pay" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSDictionary *attributes = nil;
                if (response.success) {
                    attributes = response.data;
                }
                if (block) block(attributes, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}

- (void)callbackOfPaymentID:(NSString *)paymentID paymentType:(ZBPaymentType)paymentType withBlock:(void (^)(NSString *callbackURLString, MLResponse *response))block {
    NSMutableDictionary *parameters = [[self dictionaryWithCommonParameters] mutableCopy];
    parameters[@"payno"] = paymentID;
    NSString *path = @"pay/wxpay";//微信
    if (paymentType == ZBPaymentTypeAlipay) {
        path = @"pay/alipay";
    }
    [self checkTicketWithBlock:^(BOOL valid, NSError *error) {
        if (valid) {
            [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                MLResponse *response = [[MLResponse alloc] initWithResponseObject:responseObject];
                NSString *callbackURLString = nil;
                if (response.success) {
                    callbackURLString = response.data[@"notifyurl"];
                }
                if (block) block(callbackURLString, response);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (block) block(nil, nil);
            }];
        }}];
}


@end
