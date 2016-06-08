//
//  ServerRequest.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//







#import <Foundation/Foundation.h>
#import "User.h"
#import "DigitInformation.h"
#import "SearchViewController.h"
#import "ShopCarGood.h"
#import "WeiboUser.h"
#import "ReceiveAddress.h"
#import "ServerConfig.h"
#import "ResultPasel.h"
#import "BindThirdLogin.h"

@interface ServerRequest : NSObject

#pragma mark - 配置列表
+ (ResultPasel *)getConfigList ;

//+ (ResultPasel *)getSizeType ;

#pragma mark - 版本
//版本检测
+ (ResultPasel *)checkVersionWithVersionNum:(float)versionNum  ;

//验证开关
+ (ResultPasel *)checkSwitchWithVersionNum:(float)versionNum ;

#pragma mark - 仓库
//获取所有仓库
+ (ResultPasel *)getAllWareHouse ;


#pragma mark - 推送通知
//设备安装
+ (ResultPasel *)letDeviceInstall:(NSString *)deviceUID AndAppVersion:(NSString *)appVersion AndWithOS:(NSNumber *)osVersion ;


//设备绑定
+ (ResultPasel *)bindDeviceUID:(NSString *)deviceUID AndAccount:(NSString *)account ;




#pragma mark - 注册 登陆
//用户注册
+ (ResultPasel *)registerWithUser:(User *)user ;

//Oauth2-获取用户authorize
+ (ResultPasel *)getAuthorizeWithUserName:(NSString *)username AndWithPassword:(NSString *)password ;

//Oauth2-获取用户accesstoken
+ (NSString *)getAccessTokenWithTempCode:(NSString *)code               ;

//微博用户信息
+ (NSDictionary *)getWeiboUserInfoWithToken:(NSString *)weiboToken
                                 AndWithUid:(NSString *)uid             ;

//账号-获取用户临时hash H5
+ (ResultPasel *)getTempHashToLoginH5WithUid:(NSString *)uid
                                 AndWithTime:(long long)tick            ;

//发送短信
/*
 *  phoneNumber         手机号
 *  templetCode         模板code    e.g. 注册reg
 *  key_array           json        Key的数组 e.g. keyArray(name->’XXX’,XXXX->oooo)  , 注册时传递nil
**/
+ (ResultPasel *)sendSMSWithPhoneNum:(NSString *)phoneNumber AndWithTempletCode:(NSString *)templetCode AndWithKeyArray:(NSArray *)keyArray  ;

//校验账号
/*
 *  account  手机号/邮箱
**/
+ (ResultPasel *)checkAccountWithAccount:(NSString *)account ;

//修改密码
+ (ResultPasel *)resetNewPassword:(NSString *)password AndWithAccount:(NSString *)account ;

#pragma mark --
#pragma mark - 微信登陆
+ (NSDictionary *)weixinApiGetAccessTokenWithCode:(NSString *)code ;
+ (NSDictionary *)weixinGetUserInfoWithAccessToken:(NSString *)accessToken AndWithOpenID:(NSString *)openID ;

#pragma mark - 第三方登录, 绑定

/*****************************************************
 第三方登录-校验绑定状态
 *@param :
 client_key             String	Y	分配给客户端的key
 client_secret          String	Y	分配给客户端的秘钥
 connect_type           String	Y	第三方类型qq,weibo,
 connect_user           String	Y	第三方用户
 connect_access_token	String	Y	第三方用户授权令牌
 
 *@return :
 client_key             String      分配给客户端的key
 user_id                Integer     用户id
 access_token           String      用户访问授权
******************************************************/
+ (ResultPasel *)thirdLoginCheckConnectWithThirdLoginObj:(BindThirdLogin *)loginObj ;



/*****************************************************
 第三方登录-检查是否绑定第三方账号
 *@param :
 client_key     String	Y	分配给客户端的key
 client_secret	String	Y	分配给客户端的秘钥
 connect_type	String	Y	第三方类型
 account        String	Y	站内账号
 password       String	Y	站内密码
 *****************************************************/
+ (ResultPasel *)thirdLoginCheckBindWithThirdLoginObj:(BindThirdLogin *)loginObj AndAccount:(NSString *)account AndWithPassword:(NSString *)password ;


/*****************************************************
 第三方登录-创建账号
 *@param :
 client_key             String	Y	分配给客户端的key
 client_secret          String	Y	分配给客户端的秘钥
 connect_type           String	Y	第三方类型
 connect_user           String	Y	第三方用户
 connect_access_token	String	Y	第三方用户授权令牌
 user_name              String	Y	用户昵称
 user_sex               String	N	用户性别 1男 2女 0保密，为空1
 connect_refresh_token	String	N	自动授权token
 connect_remind_in      String	N	授权提醒时间
 connect_expires_in     String	N	授权结束时间
 
 *@return :
 client_key             String	分配给客户端的key
 user_id                Integer	用户id
 access_token           String	用户访问授权
 *****************************************************/
+ (ResultPasel *)thirdLoginCreateConnectWithThirdLoginObj:(BindThirdLogin *)loginObj ;



/*****************************************************
 第三方登录-注册账号
 *@param :
 client_key             String	Y	分配给客户端的key
 client_secret          String	Y	分配给客户端的秘钥
 connect_type           String	Y	第三方类型
 connect_user           String	Y	第三方用户
 connect_access_token	String	Y	第三方用户授权令牌
 phone                  String	Y	手机号码/account
 password               String	Y	用户密码
 user_name              String	Y	用户昵称
 user_sex               String	N	用户性别 1男 2女 0保密，为空1
 connect_refresh_token	String	N	自动授权token
 connect_remind_in      String	N	授权提醒时间
 connect_expires_in     String	N	授权结束时间
 
 *@return 
 client_key             String	分配给客户端的key
 user_id                Integer	用户id
 access_token           String	用户访问授权
 *****************************************************/
+ (ResultPasel *)thirdLoginRegisterConnectWithThirdLoginObj:(BindThirdLogin *)loginObj
                                               AndWithPhone:(NSString *)phoneNumber
                                            AndWithPassword:(NSString *)password        ;


/*****************************************************
 第三方登录-绑定账号
 *@param :
 client_key             String	Y	分配给客户端的key
 client_secret          String	Y	分配给客户端的秘钥
 connect_type           String	Y	第三方类型
 connect_user           String	Y	第三方用户
 connect_access_token	String	Y	第三方用户授权令牌
 account                String	Y	账号
 password               String	N	密码
 connect_refresh_token	String	N	自动授权token
 connect_remind_in      String	N	授权提醒时间
 connect_expires_in     String	N	授权结束时间
 
 *@return :
 client_key	String	分配给客户端的key
 user_id	Integer	用户id
 access_token	String	用户访问授权
 *****************************************************/
+ (ResultPasel *)thirdLoginBindWithThirdLoginObj:(BindThirdLogin *)loginObj
                                  AndWithAccount:(NSString *)account
                                 AndWithPassword:(NSString *)password       ;





#pragma mark - 个人中心
//get 个人中心-我的资料
+ (ResultPasel *)getMyUserInfo ;

//change 个人中心-用户信息修改
+ (NSString *)changeUserInfoWith:(User *)user  ;

//获取上传头像token
+ (NSString *)getUploadPictureWithPictureName:(NSString *)picName AndWithBuckect:(NSString *)bucket ;

//公共-行政区域列表
+ (NSDictionary *)getAllArea ;

//我的优惠券
+ (ResultPasel *)getMyCoupsonListWithPage:(int)page AndWithSize:(int)size ;

//我的积分
+ (ResultPasel *)getMyPointsWithPage:(int)page AndWithSize:(int)size ;

#pragma mark - 收货地址
//新增收货地址
+ (BOOL)addAddressWithAddress:(ReceiveAddress *)address ;

//修改收货地址
+ (BOOL)editAddressWithAddress:(ReceiveAddress *)address ;

//拿收货地址列表
+ (NSArray *)getMyAddressList ;

//删除收货地址
+ (BOOL)deleteAddressWithID:(int)addressID ;



#pragma mark - 身份证
//身份证-查询单个
+ (ResultPasel *)getIdCardWithIdCardNO:(NSString *)idcard ;

//身份证-更新
/*
 加密方式：
 Key：E(LBaGt]IW
 Md5（身份证号码+key+时间）
 */
+ (ResultPasel *)addIdCard:(NSString *)idcardNO AndWithFront:(NSString *)front AndWithBack:(NSString *)back ;


#pragma mark - 首页
//获取首页 信息
+ (ResultPasel *)getIndexListWithTagID:(int)tag_id ; // tag_id . 首页不传 ;
//获取活动
+ (ResultPasel *)getActivityWithPage:(int)page AndWithTagID:(int)tagID ;
//首页tags
+ (ResultPasel *)getTopicTags ;

#pragma mark - 商品
/*  
 *          商品分类
 *  upid    父分类ID，0则是第一级
 */
+ (NSArray *)getGoodsCatagoriesWithUpid:(int)upid ;


//拿商品分类表
+ (NSArray *)getAllCataTB ;

/* 
 **************** 商品列表 ****************
 *  page	int	N		页码 默认0
 *  size	Int	N		每页返回数量 默认20
 *  seller_id	int	n		卖家id
 *  title	string	N		商品标题关键字
 *  brand	string	N		品牌关键字
 *  category	string	N		查询条件：分类id 多个分类id用“,”分割101,10111 默认无
 *  low_price	float	N		价格区间最低价格
 *  hig_price	float	N		价格区间最高价格
 *  order_val	INT	N		排序的值 1价格 2评论
 *  order_way	int	N		排序的方法 1 升序 2降序
 *  session_code	string	Y		用户的Token
 *  is_cn       int             是否中文 1 , 0
 *  is_cx       int             是否促销 1 , 0
 *****************************************
 */
+ (NSString *)getGoodsListWithCurrentSort:(CurrentSort *)currentSort ;


//商品详情
+ (NSString *)getGoodsDetailWithGoodsCode:(NSString *)goodsCode ;



//按 首字母 和 分类 , 拿品牌
+ (NSDictionary *)getBrandListWithFirstLetter:(NSString *)letter AndWithCategoryNum:(int)cate ;

//按 分类 拿 品牌
+ (NSDictionary *)getBrandListWithCateNum:(int)cate ;


//拿所有商家信息
+ (NSDictionary *)getSellerList ;


//商品-评价列表
+ (ResultPasel *)getProductCommentListWithProCode:(NSString *)proCode  AndWithPage:(int)page AndWithSize:(int)size AndWithScore:(NSArray *)scoreArray ;

//热词搜索
+ (ResultPasel *)getHotSearchList ;







#pragma mark - 购物车
//购物车-总数统计
+(NSDictionary *)getCartCount ;

//查看购物撤 shopCargood list
+ (NSDictionary *)showShopCars ;

//添加到购物车  返回购物车id(cid)  0为失败
+ (ResultPasel *)add2ShopCarWithProductID:(NSString *)pid AndWithNums:(int)nums ;

//修改购物车
+ (BOOL)changeShopCarWithCid:(int)cid AndWithNums:(int)nums ;

//删除购物车
+ (BOOL)deleteShopCarWithCid:(int)cid ;

//运费计算
+ (ResultPasel *)calculateFreightWithCidLists:(NSArray *)cidLists ;

#pragma mark - 核价
//核价
+ (NSArray *)checkPriceWithList:(NSArray *)productList;

//需要核价的商家
+ (ResultPasel *)getCheckPriceSeller ;


#pragma mark --
#pragma mark - 订单
//获取确认订单
+ (NSDictionary *)getCheckOutListWithCidList:(NSArray *)cidList ;

/***********************************
 *            创建订单              *
 ***********************************
 * @parame :    cartIDList  购物车列表
 *              addressID   地址id
 *              payType     支付方式
 *              couponID    优惠券id
 *              cousoncode  优惠码
 *              point       积分
 *
 * @return :    id          订单id
 ***********************************/
+ (NSDictionary *)addOrderWithCartIDList:(NSArray *)cartIDList
                        AndWithAddressID:(NSString *)addressID
                          AndWithPayType:(NSString *)payType
                         AndWithCouponID:(NSString *)couponID
                       AndWithCouponCode:(NSString *)coupsonCode
                           AndWithCredit:(int)points ;

//订单详情
+ (NSDictionary *)getOrderDetailWithOrderID:(NSString *)orderID ;


/***
 * 订单列表
 * page         页码
 * number       每页数量
 * status       状态条件, 0表示全部
 */
+ (NSDictionary *)getOrderListsWithPage:(int)page
                          AndWithNumber:(int)number
                          AndWithStatus:(int)status  ;

//使用积分
/*  @param  : credit      积分
 *  @return : price      减免金额
 */
+ (ResultPasel *)usePointInOrderConfrimWithCredit:(int)credit ;

//使用优惠码
/*  使用优惠码
 *  @param  :  coupsonCode  优惠码
 *             cids         购物车ids , 逗号分隔 , 字符串
 *  @return :  price        减免金额
 */
+ (ResultPasel *)useCoupsonCodeInOrderConfrimWithCoupsonCode:(NSString *)coupsonCode AndWithCidsList:(NSArray *)cidlist ;

//取消订单
+ (ResultPasel *)orderCancelWithOrderIDStr:(NSString *)orderIDStr ;

#pragma mark - 包裹
//包裹列表
+ (ResultPasel *)getBagListWithParcelID:(int)parcelID ;
//包裹详情
+ (ResultPasel *)getBagDetailWithParcelID:(int)parcelID AndWithBagID:(int)bagID ;
//包裹签收
+ (ResultPasel *)receiveBagWithBagID:(int)bagID  ;

#pragma mark - 设置
//用户反馈
/*
 * 1001 标题为空, 1002 内容为空, 1003 邮箱为空
 */
+ (int)sendUserFeedBackWithEmail:(NSString *)email
                    AndWithTitle:(NSString *)title
                  AndWithContent:(NSString *)content;


#pragma mark - 快递
//快递查询
+ (NSDictionary *)getExpressInfoWithExpressID:(int)expressID ;
//中国快递查询
+ (NSDictionary *)getChinaExpressInfoWithKuaidiNumber:(NSString *)kuaidiNum AndWithKuaidiName:(NSString *)kuaidiName ;

#pragma mark - 喜欢
//喜欢列表
+ (ResultPasel *)getLikeListWithPage:(int)page AndWithSize:(int)size ;

//喜欢 创建
+ (ResultPasel *)likeCreateWithProductCode:(NSString *)proCode ;

//喜欢 删除
+ (ResultPasel *)likeRemoveWithProductCode:(NSString *)proCode ;

//喜欢 查询
+ (BOOL)likeCheckedAlreadyWithProductCode:(NSString *)proCode ;

#pragma mark - 评价
//评价 创建
/*
*******************************************************
** 参数名                 类型   必需	说明              **
** token                String	Y	用户的Token
** score                Int     Y	评分
** image                String	Y	晒图，多个图片用“,”分割
** comment              String	Y	评论内容
** orders_product_id	Int     Y	订单商品id
** product_code         String	Y	商品编号
*******************************************************
* Code	Info
* 502	添加评论失败，如果出现该问题说明程序bug了
* 1001	评分为空
* 1002	评分内容为空
* 1003	评价商品为空
* 1004	已经评价过了
*******************************************************
**/
+ (ResultPasel *)commentCreateWithScore:(int)score AndWithImgList:(NSArray *)imgList AndWithComment:(NSString *)commentStr AndWithOrdersProductID:(int)orderProID AndWithProductCode:(NSString *)productCode ;

//评价-列表-全部【包含有评价和没有评价】
/*
 *******************************************************
 *参数名	类型          必需	说明
 *token	String      Y       用户的Token
 *page	Int         N       页码，从第一页开始计算
 *size	Int         N       每页显示多少条
 *******************************************************
*/
+ (ResultPasel *)getMyAllCommentListWithPage:(int)page AndWithSize:(int)size ;


//评价-列表-已经评价
/*
 ************************************
 *参数名	类型        必需     说明
 *token	String      Y       用户的Token
 *page	Int         N       页码，从第一页开始计算
 *size	Int         N       每页显示多少条
 ************************************
 */
+ (ResultPasel *)getMyAlreadyCommentWithPage:(int)page AndWithSize:(int)size ;


//评价-单个评价【包含带分页的回复信息】
/*
 ************************************
 *参数名	类型          必需	说明
 *token	String      Y       用户的Token
 *id	Int         Y       评论id
 *page	Int         N       页码，从第一页开始计算
 *size	Int         N       每页显示多少条
 ************************************
 */
+ (ResultPasel *)getSingleCommentWithCommentID:(int)commentID AndWithPage:(int)page AndWithSize:(int)size ;


//评价-回复评价
/*
 ************************************
 *参数名           类型      必需	说明
 *token         String      Y	用户的Token
 *content       String      Y	回复内容
 *comment_id	Int         Y	回复的评论id
 *reply_id      Int         Y	回复的回复id【子回复】
 ************************************
 */
+ (ResultPasel *)answerCommentWithContent:(NSString *)content AndWithCommentID:(int)commentID AndWithReplyID:(int)replyID ;

#pragma mark - 收银台
//查询支付流水
/*
 *参数名         类型	必需		说明
 *token         String	Y		用户的Token
 *orders_code	String	Y		订单编号
 **/
+ (ResultPasel *)cashierGetPaymentWithOrderCode:(NSString *)orderCode ;



#pragma mark - 帮助中心
//帮助中心
+ (ResultPasel *)getHelpCenterWithType:(NSString *)type ;


@end





