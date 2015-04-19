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

/// MLAPIClient 接口类.
@interface MLAPIClient : AFHTTPRequestOperationManager

/**
 * @brief 工具方法.
 *
 */
+ (instancetype)shared;
- (BOOL)sessionValid;
- (void)makeSessionInvalid;
- (NSString *)userAccount;
- (void)removeUserAccount;

/**
 * @brief App注册.
 *
 * @param location 位置.
 *
 */
- (void)appRegister:(CLLocation *)location
          withBlock:(void (^)(NSDictionary *attributes, NSError *error))block;

/**
 * @brief 获取ticket.
 *
 */
- (void)ticketWithBlock:(void (^)(NSDictionary *attributes, NSError *error))block;

/**
 * @brief 获取app最新版本.
 *
 */
- (void)checkVersionWithBlock:(void (^)(NSDictionary *attributes, NSError *error))block;

/**
 * @brief 发送验证码.
 *
 * @param verfyCode 参数.
 *
 */
- (void)fetchVervifyCode:(MLVerifyCode *)verifyCode
               withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 验证验证码是否有效.
 *
 * @param verifyCode 参数.
 *
 */
- (void)checkVervifyCode:(MLVerifyCode *)verifyCode
               withBlock:(void (^)(MLResponse *response))block;

#pragma mark - Goods
/**
 * @brief 获取商品分类.
 *
 */
- (void)goodsClassifiesWithBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

/**
 * @brief 商品评论.
 *
 * @param goodsId 商品id.
 * @param flag flag.
 * @param page 页数.
 *
 */
- (void)goodsComments:(NSString *)goodsId commentFlag:(NSString *)flag currentPage:(int)page withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 搜索商品.
 *
 * @param classifyID 商品分类id.
 * @param keywords 关键字.
 * @param price 价格.
 * @param spec 规格参数（规格:值;规格:值;…）例：”品牌:雅诗兰黛;适用人群:女士”.
 * @param orderby 排序字段，可选[time/price/salesvolume/hignopinion]，对应[最新/价格/销量/好评度].
 * @param ascended 升序或降序.
 * @param orderway 排序方式，只有orderby参数=price时才用到，可选[0/1]，对应[升序/降序].
 * @param page 页码.
 * @param pagesize 需要返回的数据数量.
 *
 */
- (void)searchGoodsWithClassifyID:(NSString *)classifyID
                         keywords:(NSString *)keywords
                            price:(NSString *)price
                             spec:(NSString *)spec
                          orderby:(NSString *)orderby
                         ascended:(BOOL)ascended
                        stockflag:(int)sflag
                      voucherflag:(int)vflag
                             page:(NSNumber *)page
                        withBlock:(void (^)(NSArray *multiAttributes, NSError *error,NSDictionary *attributes))block;


/**
 * @brief 商品详情.
 *
 * @param goodsID 商品ID.
 *
 */
- (void)goodsDetails:(NSString *)goodsID
           withBlock:(void (^)(NSDictionary *attributes, NSArray *multiAttributes, MLResponse *response))block;

/**
 * @brief 获取商品规格.
 *
 * @param goodsID 商品ID.
 *
 */
- (void)goodsProperties:(NSString *)goodsID withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

/**
 * @brief 获取商品图文详情.
 *
 * @param goodsID 商品ID.
 *
 */
- (void)goodsImagesDetails:(NSString *)goodsID
                 withBlock:(void (^)(NSDictionary *attributes, NSError *error))block;

/**
 * @brief 收藏或取消收藏.
 *
 * @param goodsID 商品ID.
 * @param favorite 是否收藏.
 *
 */
- (void)goods:(NSString *)goodsID
       favour:(BOOL)favorite withBlock:(void (^)(NSString *message, NSError *error))block;

/**
 * @brief 获取热词(商品或者商铺热词).
 *
 * @param goodsOrStore 商品还是商铺.
 *
 */
- (void)searchHotwordsForGoods:(BOOL)goodsOrStore withBlock:(void (^)(NSArray *words, MLResponse *response))block;

/**
 * @brief 获取商家搜索.
 *
 * @param cityID 用户所选城市(如苏州 66).
 * @param classifyID 分类id.
 * @param circleID 商圈id.
 * @param distance 距离（km).
 * @param keyword 商家名，分类或商圈.
 * @param sortType 排序方式.
 * @param page 1-距离（默认），2-时间倒序.
 *
 */
- (void)searchStoresWithCityID:(NSNumber *)cityID
                    classifyID:(NSString *)classifyID
                      circleID:(NSString *)circleID
                      distance:(NSNumber *)distance
                       keyword:(NSString *)keyword
                          sort:(MLSortType)sortType
                          page:(NSNumber *)page
                     withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;

/**
 * @brief 多商品删除收藏.
 *
 * @param multiGoodsIDs 商品id的数组.
 *
 */
- (void)multiGoods:(NSArray *)multiGoodsIDs
 defavourWithBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 获取商品某组规格所对应价格.
 *
 * @param goods 商品信息.
 * @param selectedPropertiesString 商品某组规格, 该参数传递每个规格在组里的下标并-隔开（例：1-0-2对应的规格组为“天空蓝、中国移动、规格值3”）相应，如果用户选择“土豪金，中国联通，规格值2”这组规格，那么该参数应该传值：0-1-1 服务器会根据规格坐标，定位商品价格.
 *
 */
- (void)priceForGoods:(MLGoods *)goods
   selectedProperties:(NSString *)selectedPropertiesString withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;


#pragma mark - Store
/**
 * @brief 实体店 - 获取城市列表.
 *
 */
- (void)citiesWithBlock:(void (^)(NSDictionary *attributes, NSArray *multiAttributes, NSError *error))block;

/**
 * @brief 热推商家/猜你喜欢.
 *
 * @param cityID 城市ID.
 * @param hot hot为no的话为猜你喜欢
 *
 */
- (void)storesWithCityID:(NSNumber *)cityID
                     hot:(BOOL)hot
               withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

/**
 * @brief 获取实体店商家详情.
 *
 * @param storeID 实体店ID.
 *
 */
- (void)storeDetails:(NSString *)storeID withBlock:(void (^)(NSDictionary *attributes, NSError *error))block;

/**
 * @brief 实体折扣店评价.
 *
 * @param storeID 实体店ID.
 * @param page
 *
 */
- (void)storeComments:(NSString *)storeID
                 page:(NSNumber *)page
            withBlock:(void (^)(NSNumber *highOpinion, NSNumber *commentsNumber, NSArray *multiAttributes, NSError *error))block;

/**
 * @brief 提交实体店评论.
 *
 * @param storeID 实体店ID.
 * @param star 星级
 * @param content 内容
 *
 */
- (void)submitCommentOfStore:(NSString *)storeID
                        star:(NSNumber *)star
                     content:(NSString *)content
                   withBlock:(void (^)(NSError *error))block;


/**
 * @brief 获取商家分类.
 *
 */
- (void)storeClassifiesWithBlock:(void (^)(NSArray *multiAttribues, MLResponse *response))block;

/**
 * @brief 城市下的区和商圈.
 *
 */
- (void)storeCirclesWithBlock:(void(^)(NSArray *distances, NSArray *multiAttributtes, MLResponse *response))block;

/**
 * @brief 收藏或取消收藏.
 *
 * @param favour 收藏或取消.
 */
- (void)store:(MLStore *)store
       favour:(BOOL)favour withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 批量取消收藏.
 *
 * @param storeIDs 商铺id数组.
 */
- (void)stores:(NSArray *)storeIDs
defavourWithBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 旗舰店详情.
 *
 * @param flagshipStoreID 旗舰店id.
 */
- (void)detailsOfFlagshipStoreID:(NSString *)flagshipStoreID
                       withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 旗舰店中的商品.
 *
 * @param flagshipStoreID 旗舰店id.
 * @param page 页码.
 */
- (void)multiGoodsInFlagshipStoreID:(NSString *)flagshipStoreID
                               page:(NSNumber *)page
                          withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;

/**
 * @brief 收藏旗舰店.
 *
 * @param flagshipStoreID 旗舰店id.
 *
 */
- (void)favourFlagshipStoreID:(NSString *)flagshipStoreID
                    withBlock:(void (^)(MLResponse *response))block;

#pragma mark - Cart

/**
 * @brief 加入购物车.
 *
 * @param goodsID 商品id.
 * @param properties 规格.
 * @param number 数量.
 *
 */
- (void)addCartWithGoods:(NSString *)goodsID
              properties:(NSString *)properties
                  number:(NSNumber *)number
               withBlock:(void (^)(NSError *error))block;

/**
 * @brief 同步购物车.
 *
 * @param page 页数.
 *
 */
- (void)syncCartWithPage:(NSNumber *)page
               withBlock:(void (^)(NSArray *multiAttributes, NSNumber *total, NSError *error))block;

/**
 * @brief 删除购物车中的商品.
 *
 * @param multiGoods 多个商品.
 *
 */
- (void)deleteMultiGoods:(NSArray *)multiGoods
               withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 修改购物车中的商品.
 *
 * @param multiGoods 多个商品.
 *
 */
- (void)updateMultiGoods:(NSArray *)multiGoods
               withBlock:(void (^)(MLResponse *response))block;

#pragma mark - Sign
/**
 * @brief 登录.
 *
 * @param account 账号.
 * @param password 密码.
 *
 */
- (void)signinWithAccount:(NSString *)account
                 password:(NSString *)password
                withBlock:(void (^)(NSDictionary *attributes, MLResponse *response, NSError *error))block;

/**
 * @brief 自动登录.
 *
 */
- (void)autoSigninWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response, NSError *error))block;

/**
 * @brief 修改密码.
 *
 * @param verfiyCode 验证码信息
 * @param password 密码
 * @param passwordConfirm 确认密码.
 *
 */
- (void)identifyWithVerifyCode:(MLVerifyCode *)verifyCode
                      password:(NSString *)password
               passwordConfirm:(NSString *)passwordConfirm
                     withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 用户注册注册协议.
 *
 */
- (void)fetchSignupTermsWithBlock:(void (^)(NSString *URLString, NSString *message, NSError *error))block;

/**
 * @brief 修改密码.
 *
 * @param oldPassword 旧密码.
 * @param newPassword 新密码.
 * @param newPasswordConfirm 确认新密码.
 *
 */
- (void)changeOldPassword:(NSString *)oldPassword
              newPassword:(NSString *)newPassword
       newPasswordConfirm:(NSString *)newPasswordConfirm
                withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 用户注销.
 *
 */
- (void)signoutWithBlock:(void (^)(NSString *message, NSError *error))block;

#pragma mark -GoodsComment
/**
 * @brief 评价-某个订单待评价的商品.
 *
 * @param orderNo 订单号.
 *
 */
- (void)orderCommentInfo:(NSString *)orderNo
               WithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 发布评论.
 *
 * @param orderNo 订单号.
 * @param commentInfo 评论信息.
 *
 */
- (void)sendComment:(NSString *)orderNo
        commentInfo:(NSString *)commentInfo
          WithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;
#pragma mark - Me

/**
 * @brief 用户的收藏数量.
 *
 */
- (void)myfavoritesSummaryWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 我收藏的商品.
 *
 * @param page 页数.
 *
 */
- (void)favoritesGoodsWithPage:(NSNumber *)page
                     withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

/**
 * @brief 我收藏的旗舰店.
 *
 * @param page 页数.
 *
 */
- (void)favoritesFlagshipStoreWithPage:(NSNumber *)page
                             withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

/**
 * @brief 我收藏的实体店.
 *
 * @param page 页数.
 *
 */
- (void)favoritesStoreWithPage:(NSNumber *)page
                     withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

/**
 * @brief 我的消息.
 *
 * @param page 页数.
 *
 */
- (void)messagesWithPage:(NSNumber *)page
               withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;

/**
 * @brief 电子会员卡.
 *
 */
- (void)memeberCardWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 批量取消收藏实体店.
 *
 * @param flagStoreIDs 实体店数组.
 *
 */
- (void)flagStores:(NSArray *)flagStoreIDs
 defavourWithBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 检测是否有新的消息.
 *
 */
- (void)numberOfNewMessagesWithBlock:(void (^)(NSNumber *number, MLResponse *response))block;

/**
 * @brief 消息详情.
 *
 * @param message 消息信息.
 *
 */
- (void)detailsOfMessage:(MLMessage *)message
               withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 删除消息.
 *
 * @param message 消息信息.
 *
 */
- (void)deleteMessage:(MLMessage *)message
            withBlock:(void (^)(MLResponse *response))block;

#pragma mark - Address
/**
 * @brief 获取用户地址.
 *
 */
- (void)addressesWithBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block;

/**
 * @brief 新增地址.
 *
 * @param address 地址信息.
 *
 */
- (void)addAddress:(MLAddress *)address
         withBlock:(void (^)(NSString *message, NSError *error))block;

/**
 * @brief 设置默认地址.
 *
 * @param addressID 地址Id.
 *
 */
- (void)setDefaultAddress:(NSString *)addressID
                withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 删除地址.
 *
 * @param addressID 地址Id.
 *
 */
- (void)deleteAddress:(NSString *)addressID
            withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 获取省份.
 *
 *
 */
- (void)provincesWithBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block;

/**
 * @brief 获取城市.
 *
 * @param provinceID 省份Id.
 *
 */
- (void)areasInProvince:(NSNumber *)provinceID withBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block;

/**
 * @brief 地址详情.
 *
 * @param addressID 地址Id.
 *
 */
- (void)detailsOfAddress:(NSString *)addressID withBlock:(void (^)(NSDictionary *attributes, NSString *message, NSError *error))block;

/**
 * @brief 我的代金券.
 *
 */
- (void)myVoucherWithBlock:(void (^)(NSNumber *voucherValue, MLResponse *response))block;

/**
 * @brief 可领取的代金券.
 *
 * @param page 页数.
 *
 */
- (void)newVoucherPage:(NSNumber *)page
             withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;

/**
 * @brief 领取代金券.
 *
 * @param voucher 代金券信息.
 *
 */
- (void)takeVoucher:(MLVoucher *)voucher
          withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 代金券使用细则.
 *
 * @param type 类型.
 * @param page 页数.
 *
 */
- (void)voucherFlowWithType:(MLVoucherFlowType)type
                       page:(NSNumber *)page
                  withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;

/**
 * @brief 订单可领取代金券金额.
 *
 * @param voucher 代金券信息.
 *
 */
- (void)voucherValueWillGet:(MLVoucher *)voucher
                  withBlock:(void (^)(NSNumber *value, MLResponse *response))block;

#pragma mark - Order
/**
 * @brief 获取订单列表.
 *
 * @param status 状态 forpay待支付 forsend待发货 fortake待收货 forcomment待评价.
 * @page  页数.
 *
 */
- (void)orders:(NSString *)status
          page:(NSNumber *)page
     withBlock:(void (^)(NSArray *multiAttributes, NSString *message, NSError *error))block;

/**
 * @brief 确认订单信息.
 *
 * @param multiGoods 商品.
 * @param buyNow 是否是立即购买.
 * @param addressID 地址Id.
 *
 */
- (void)prepareOrder:(NSArray *)multiGoods
              buyNow:(BOOL)buyNow
           addressID:(NSString *)addressID
           withBlock:(void (^)(BOOL vip, NSDictionary *addressAttributes, NSDictionary *voucherAttributes, NSArray *multiGoodsWithError, NSArray *multiGoods, NSNumber *totalPrice, MLResponse *response))block;

/**
 * @brief 保存订单.
 *
 * @param cartStores 商品.
 * @param buyNow 是否是立即购买.
 * @param addressID 地址Id.
 * @param voucher 代金券信息.
 * @param walletPassword 支付密码.
 *
 */
- (void)saveOrder:(NSArray *)cartStores
           buyNow:(BOOL)buyNow
          address:(NSString *)addressID
          voucher:(MLVoucher *)voucher
   walletPassword:(NSString *)walletPassword
        withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 取消售后服务.
 *
 * @param orderNo 订单编号.
 * @param goodsId 商品Id.
 * @param tradeId .
 * @param type 类别.
 *
 */
- (void)cancelService:(NSString *)orderNo
              goodsId:(NSString *)goodsId
              tradeId:(NSString *)tradeId
                 type:(NSString *)type
            withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 订单商品操作.
 *
 * @param order 订单信息.
 * @param orderOperator 操作信息.
 * @param afterSalesGoods 待操作商品.
 * @param password 密码.
 *
 */
- (void)operateOrder:(MLOrder *)order
       orderOperator:(MLOrderOperator *)orderOperator
     afterSalesGoods:(MLAfterSalesGoods *)afterSalesGoods
            password:(NSString *)password
           withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;
/**
 * @brief 订单详情.
 *
 * @param orderNo 订单编号.
 *
 */
- (void)orderProfile:(NSString *)orderNo
           withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 订单信息概况-不同状态的订单数目等.
 *
 */
- (void)myOrdersSummaryWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 售后服务-退换货商品列表.
 *
 * @param change 类型.
 * @param page 页数.
 */
- (void)afterSalesGoodsChange:(BOOL)change
                         page:(NSNumber *)page
                    withBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;

/**
 * @brief 申请售后服务-保存申请信息.
 *
 * @param afterSalesGoods 商品信息.
 * @param reason 原因.
 * @param imagePaths 图片.
 * @param addressID 地址Id.
 */
- (void)afterSalesAdd:(MLAfterSalesGoods *)afterSalesGoods
               reason:(NSString *)reason
           imagePaths:(NSArray *)imagePaths
            addressID:(NSString *)addressID
            withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 售货服务-获取商家收货地址.
 *
 * @param afterSalesGoods 商品信息.
 *
 */
- (void)fetchBussinessInfoForAfterSales:(MLAfterSalesGoods *)afterSalesGoods
                              withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 保存物流信息 (给商家用的).
 *
 * @param afterSalesGoods 商品信息.
 * @param buyerName 买家姓名.
 * @param buyerPhone 买家手机.
 * @param logisticCompany 快递名称.
 * @param logisticNO 快递单号.
 * @param remark 备注.
 *
 */
- (void)afterSalesSaveLogistic:(MLAfterSalesGoods *)afterSalesGoods buyerName:(NSString *)buyerName buyerPhone:(NSString *)buyerPhone logisticCompany:(NSString *)logisticCompany logisitcNO:(NSString *)logisticNO remark:(NSString *)remark withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 售后服务-商品售后详情.
 *
 * @param afterSalesGoods 商品信息.
 *
 */
- (void)fetchAfterSalesDetailInfo:(MLAfterSalesGoods *)afterSalesGoods
                        withBlock:(void (^)(MLResponse *response))block;

#pragma mark - AD

/**
 * @brief 店铺广告.
 *
 * @param forStores 广告类型.
 *
 */
- (void)advertisementsInStores:(BOOL)forStores withBlock:(void (^)(NSString *style, NSArray *multiAttributes, MLResponse *response, NSError *error))block;

#pragma mark - Share

/**
 * @brief 分享内容获取.
 *
 * @param object 信息.
 * @param platform 平台.
 * @param objectID id.
 *
 */
- (void)shareWithObject:(MLShareObject)object
               platform:(MLSharePlatform)platform
               objectID:(id)objectID
              withBlock:(void(^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 分享的回调.
 *
 * @param object 信息.
 * @param platform 平台.
 * @param objectID id.
 *
 */
- (void)shareCallbackWithObject:(MLShareObject)object
                       platform:(MLSharePlatform)platform
                       objectID:(NSString *)objectID
                      withBlock:(void (^)(MLResponse *response))block;


#pragma mark - User
/**
 * @brief 用户信息.
 *
 */
- (void)userInfoWithBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 更新用户信息.
 *
 * @param user 用户信息.
 *
 */
- (void)updateUserInfo:(MLUser *)user
             withBlock:(void (^)(MLResponse *response))block;

/**
 * @brief 充值、续费-获取计费信息.
 *
 */
- (void)VIPFeeWithBlock:(void (^)(NSArray *multiAttributes, MLResponse *response))block;

/**
 * @brief 会员充值、续费-获取付款信息.
 *
 * @param VIPFee vip信息.
 */
- (void)preparePayVIP:(MLVIPFee *)VIPFee
            withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

#pragma mark -	AppsInfo
/**
 * @brief app信息.
 *
 */
- (void)appsInfoWithBlock:(void (^)(NSDictionary *attributes, NSError *error))block;

/**
 * @brief 附近的店.
 *
 * @param cityId 城市Id.
 */
- (void)nearByStoreList:(NSString *)cityId
              withBlock:(void (^)(NSArray *multiAttributes, NSError *error))block;

/**
 * @brief 上传图片.
 *
 * @param image 图片.
 */
- (void)uploadImage:(UIImage *)image
          withBlock:(void (^)(NSString *imagePath, MLResponse *response))block;

/**
 * @brief 上传图片.
 *
 * @param path 路径.
 */
- (void)fetchImageWithPath:(NSString *)path
                 withBlock:(void (^)(UIImage *image))block;

/**
 * @brief 检查是否已经设置过交易密码.
 *
 */
- (void)userHasWalletPasswordWithBlock:(void (^)(NSNumber *hasWalletPassword, MLResponse *response))block;

/**
 * @brief 更新交易密码.
 *
 * @param password 密码.
 * @param passwordConfirm 确定密码.
 * @param currentPassword 当前密码.
 *
 */
- (void)updateWalletPassword:(NSString *)password
             passwordConfirm:(NSString *)passwordConfirm
             currentPassword:(NSString *)currentPassword
                   withBlock:(void (^)(MLResponse *response))block;

#pragma mark - Pay
/**
 * @brief 订单付款.
 *
 * @param orderIDs 订单号数组.
 *
 */
- (void)payOrders:(NSArray *)orderIDs
        withBlock:(void (^)(NSDictionary *attributes, MLResponse *response))block;

/**
 * @brief 付款回调url获取.
 *
 * @param paymentID 付款id.
 * @param paymentType 类型.
 *
 */
- (void)callbackOfPaymentID:(NSString *)paymentID
                paymentType:(ZBPaymentType)paymentType
                  withBlock:(void (^)(NSString *callbackURLString, MLResponse *response))block;


@end
