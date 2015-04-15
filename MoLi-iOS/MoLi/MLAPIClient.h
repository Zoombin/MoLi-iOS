//
//  MLAPIClient.h
//  MoLi
//
//  Created by zhangbin on 11/17/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "MLAddress.h"
#import "MLGoods.h"
#import "MLVerifyCode.h"
#import "MLUser.h"
#import "MLVoucher.h"
#import "MLCartStore.h"
#import "MLOrder.h"
#import "MLResponse.h"
#import "MLVoucherFlow.h"
#import "MLSort.h"
#import "MLShare.h"
#import "MLFlagshipStore.h"
#import "ZBPaymentManager.h"
#import "MLAfterSalesGoods.h"
#import "MLMessage.h"
#import "MLVIPFee.h"

extern NSString * const ML_ERROR_MESSAGE_IDENTIFIER;

@interface MLAPIClient : AFHTTPRequestOperationManager

+ (instancetype)shared;
- (BOOL)sessionValid;
- (void)makeSessionInvalid;
- (NSString *)userAccount;
- (void)removeUserAccount;

- (void)appRegister:(CLLocation *)location withBlock:(void (^)(NSDictionary *attributes, NSError *error))block;
- (void)ticketWithBlock:(void (^)(NSDictionary *attributes, NSError *error))block;
- (void)checkVersionWithBlock:(void (^)(NSDictionary *attributes, NSError *error))block;
- (void)fetchVervifyCode:(MLVerifyCode *)verifyCode withBlock:(void (^)(MLResponse *response))block;
- (void)checkVervifyCode:(MLVerifyCode *)verifyCode withBlock:(void (^)(MLResponse *response))block;

#pragma mark - Goods
- (void)goodsClassifiesWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
- (void)searchGoodsWithClassifyID:(NSString *)classifyID keywords:(NSString *)keywords price:(NSString *)price spec:(NSString *)spec orderby:(NSString *)orderby ascended:(BOOL)ascended stockflag:(int)sflag voucherflag:(int)vflag page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSError *error,NSDictionary *attributes))block;

- (void)goodsDetails:(NSString *)goodsID withBlock:(void (^)(NSDictionary *attributes, NSArray *multiAttributes, MLResponse *response))block;

- (void)goodsProperties:(NSString *)goodsID withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

- (void)goodsImagesDetails:(NSString *)goodsID withBlock:(void (^)(NSDictionary *attributes, NSError *error))block;
- (void)goods:(NSString *)goodsID favour:(BOOL)favorite withBlock:(void (^)(NSString *message, NSError *error))block;
- (void)searchHotwordsForGoods:(BOOL)goodsOrStore withBlock:(void (^)(NSArray *words, MLResponse *response))block;
- (void)searchStoresWithCityID:(NSNumber *)cityID classifyID:(NSString *)classifyID circleID:(NSString *)circleID distance:(NSNumber *)distance keyword:(NSString *)keyword sort:(MLSortType)sortType page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;

- (void)multiGoods:(NSArray *)multiGoodsIDs defavourWithBlock:(void (^)(MLResponse *response))block;

- (void)priceForGoods:(MLGoods *)goods selectedProperties:(NSString *)selectedPropertiesString withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;


#pragma mark - Store
//城市列表
- (void)citiesWithBlock:(void (^)(NSDictionary *attributes, NSArray *multiAttributes, NSError *error))block;
//热推商家/猜你喜欢:如果hot == NO为猜你喜欢
- (void)storesWithCityID:(NSNumber *)cityID hot:(BOOL)hot withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

//- (void)storeCategoriesWithBlock:(void (^)())
- (void)storeDetails:(NSString *)storeID withBlock:(void (^)(NSDictionary *attributes, NSError *error))block;
//实体店的评价
- (void)storeComments:(NSString *)storeID page:(NSNumber *)page withBlock:(void (^)(NSNumber *highOpinion, NSNumber *commentsNumber, NSArray *multiAttributes, NSError *error))block;
- (void)submitCommentOfStore:(NSString *)storeID star:(NSNumber *)star content:(NSString *)content withBlock:(void (^)(NSError *error))block;

- (void)storeClassifiesWithBlock:(void (^)(NSArray *multiAttribues, MLResponse *response))block;
- (void)storeCirclesWithBlock:(void(^)(NSArray *distances, NSArray *multiAttributtes, MLResponse *response))block;
- (void)store:(MLStore *)store favour:(BOOL)favour withBlock:(void (^)(MLResponse *response))block;
- (void)stores:(NSArray *)storeIDs defavourWithBlock:(void (^)(MLResponse *response))block;

//旗舰店详情
- (void)detailsOfFlagshipStoreID:(NSString *)flagshipStoreID withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

//旗舰店中的商品
- (void)multiGoodsInFlagshipStoreID:(NSString *)flagshipStoreID page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;

//收藏旗舰店
- (void)favourFlagshipStoreID:(NSString *)flagshipStoreID withBlock:(void (^)(MLResponse *response))block;

#pragma mark - Cart

- (void)addCartWithGoods:(NSString *)goodsID properties:(NSString *)properties number:(NSNumber *)number withBlock:(void (^)(NSError *error))block;

- (void)syncCartWithPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSNumber *total, NSError *error))block;

- (void)deleteMultiGoods:(NSArray *)multiGoods withBlock:(void (^)(MLResponse *response))block;
- (void)updateMultiGoods:(NSArray *)multiGoods withBlock:(void (^)(MLResponse *response))block;

#pragma mark - Sign

//登录注册
- (void)signinWithAccount:(NSString *)account password:(NSString *)password withBlock:(void (^)(NSDictionary *attributes, NSError *error))block;
- (void)autoSigninWithBlock:(void (^)(NSDictionary *attributes, NSError *error))block;
- (void)identifyWithVerifyCode:(MLVerifyCode *)verifyCode password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;
- (void)fetchSignupTermsWithBlock:(void (^)(NSString *URLString, NSString *message, NSError *error))block;
- (void)changeOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword newPasswordConfirm:(NSString *)newPasswordConfirm withBlock:(void (^)(MLResponse *response))block;
- (void)signoutWithBlock:(void (^)(NSString *message, NSError *error))block;


#pragma mark - Me

- (void)myfavoritesSummaryWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

//我收藏的商品
- (void)favoritesGoodsWithPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
//我收藏的旗舰店
- (void)favoritesFlagshipStoreWithPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
//我收藏的实体店
- (void)favoritesStoreWithPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;
//我的消息
- (void)messagesWithPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;
//电子会员卡
- (void)memeberCardWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

- (void)flagStores:(NSArray *)flagStoreIDs defavourWithBlock:(void (^)(MLResponse *response))block;

- (void)numberOfNewMessagesWithBlock:(void (^)(NSNumber *number, MLResponse *response))block;

- (void)detailsOfMessage:(MLMessage *)message withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;
- (void)deleteMessage:(MLMessage *)message withBlock:(void (^)(MLResponse *response))block;

#pragma mark - Address

- (void)addressesWithBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block;
- (void)addAddress:(MLAddress *)address withBlock:(void (^)(NSString *message, NSError *error))block;
- (void)setDefaultAddress:(NSString *)addressID withBlock:(void (^)(MLResponse *response))block;
- (void)deleteAddress:(NSString *)addressID withBlock:(void (^)(MLResponse *response))block;
- (void)provincesWithBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block;
- (void)areasInProvince:(NSNumber *)provinceID withBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block;
- (void)detailsOfAddress:(NSString *)addressID withBlock:(void (^)(NSDictionary *attributes, NSString *message, NSError *error))block;
- (void)myVoucherWithBlock:(void (^)(NSNumber *voucherValue, MLResponse *response))block;
- (void)newVoucherPage:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;
- (void)takeVoucher:(MLVoucher *)voucher withBlock:(void (^)(MLResponse *response))block;
- (void)voucherFlowWithType:(MLVoucherFlowType)type page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;
- (void)voucherValueWillGet:(MLVoucher *)voucher withBlock:(void (^)(NSNumber *value, MLResponse *response))block;

#pragma mark - Order

- (void)orders:(NSString *)status page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block;

- (void)prepareOrder:(NSArray *)multiGoods buyNow:(BOOL)buyNow addressID:(NSString *)addressID withBlock:(void (^)(BOOL vip, NSDictionary *addressAttributes, NSDictionary *voucherAttributes, NSArray *multiGoodsWithError, NSArray *multiGoods, NSNumber *totalPrice, MLResponse *response))block;

- (void)saveOrder:(NSArray *)cartStores buyNow:(BOOL)buyNow address:(NSString *)addressID voucher:(MLVoucher *)voucher walletPassword:(NSString *)walletPassword withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

- (void)cancelService:(NSString *)orderNo
              goodsId:(NSString *)goodsId
              tradeId:(NSString *)tradeId
                 type:(NSString *)type
            withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

- (void)operateOrder:(MLOrder *)order orderOperator:(MLOrderOperator *)orderOperator afterSalesGoods:(MLAfterSalesGoods *)afterSalesGoods password:(NSString *)password withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

- (void)orderProfile:(NSString *)orderNo
           withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

- (void)myOrdersSummaryWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

- (void)afterSalesGoodsChange:(BOOL)change page:(NSNumber *)page withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;

- (void)afterSalesAdd:(MLAfterSalesGoods *)afterSalesGoods reason:(NSString *)reason imagePaths:(NSArray *)imagePaths addressID:(NSString *)addressID withBlock:(void (^)(MLResponse *response))block;

- (void)fetchBussinessInfoForAfterSales:(MLAfterSalesGoods *)afterSalesGoods withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

- (void)afterSalesSaveLogistic:(MLAfterSalesGoods *)afterSalesGoods buyerName:(NSString *)buyerName buyerPhone:(NSString *)buyerPhone logisticCompany:(NSString *)logisticCompany logisitcNO:(NSString *)logisticNO remark:(NSString *)remark withBlock:(void (^)(MLResponse *response))block;

- (void)fetchAfterSalesDetailInfo:(MLAfterSalesGoods *)afterSalesGoods
                        withBlock:(void (^)(MLResponse *response))block;

#pragma mark - AD

- (void)advertisementsInStores:(BOOL)forStores withBlock:(void (^)(NSString *style, NSArray *multiAttributes, MLResponse *response))block;

#pragma mark - Share

- (void)shareWithObject:(MLShareObject)object platform:(MLSharePlatform)platform objectID:(id)objectID withBlock:(void(^)(NSDictionary *attributes, MLResponse *response))block;

- (void)shareCallbackWithObject:(MLShareObject)object platform:(MLSharePlatform)platform objectID:(NSString *)objectID withBlock:(void (^)(MLResponse *response))block;


#pragma mark - User
- (void)userInfoWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;
- (void)updateUserInfo:(MLUser *)user withBlock:(void (^)(MLResponse *response))block;
- (void)VIPFeeWithBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;
- (void)preparePayVIP:(MLVIPFee *)VIPFee withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

#pragma mark -	AppsInfo
- (void)appsInfoWithBlock:(void (^)(NSDictionary *attributes, NSError *error))block;

- (void)nearByStoreList:(NSString *)cityId withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

- (void)uploadImage:(UIImage *)image withBlock:(void (^)(NSString *imagePath, MLResponse *response))block;

- (void)fetchImageWithPath:(NSString *)path withBlock:(void (^)(UIImage *image))block;

- (void)userHasWalletPasswordWithBlock:(void (^)(NSNumber *hasWalletPassword, MLResponse *response))block;

- (void)updateWalletPassword:(NSString *)password passwordConfirm:(NSString *)passwordConfirm currentPassword:(NSString *)currentPassword withBlock:(void (^)(MLResponse *response))block;

#pragma mark - Pay

- (void)payOrders:(NSArray *)orderIDs withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

- (void)callbackOfPaymentID:(NSString *)paymentID paymentType:(ZBPaymentType)paymentType withBlock:(void (^)(NSString *callbackURLString, MLResponse *response))block;


@end
