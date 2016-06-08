//
//  serverConfig.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-27.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

/***************************
 *  server head
 *********************************************/


#ifndef JGB_serverConfig_h
#define JGB_serverConfig_h

/************************************************************************/
#pragma mark --
#pragma mark - 配置
//配置列表
#define URL_CONFIG_LIST     @"/Config/getList"

//尺码规格
#define URL_SIZE_GUIGE      @"/Article/item"


//行政区域列表
#define URL_GET_AREALIST    @"/Area/getAll"

/************************************************************************/
#pragma mark --
#pragma mark - 推送通知
//设备安装
#define URL_DEVICE_INSTALL  @"/Device/install"
//设备绑定
#define URL_DEVICE_BIND     @"/Device/bindAccount"

/************************************************************************/
#pragma mark --
#pragma mark - 版本
//版本检测
#define URL_VERSION         @"/Version/checkVersion"
//验证开关
#define URL_CHECKSWITCH     @"/Version/checkSwitch"

/************************************************************************/
#pragma mark --
#pragma mark - 仓库
//获取所有仓库
#define URL_GETALLWAREHOUSE @"/Product/getWarehouse"


/************************************************************************/
#pragma mark --
#pragma mark - 登录注册
//用户注册
#define URL_USER_REG        @"/Passport/register"

//Oauth2-获取用户authorize
#define URL_AUTHORIZE       @"/Oauth2/authorize"

//Oauth2-获取用户accesstoken
#define URL_GET_TOKEN       @"/Oauth2/accesstoken"

//get temp hash logiN h5
#define URL_GET_HASH        @"/Passport/getHash"

//发送短信
#define URL_SEND_SMS        @"/Send/sendSms"

//校验账号
#define URL_CHECK_PASSWORD  @"/Passport/checkAccount"

//找回密码
#define URL_FIND_PASSWORD   @"/Passport/forgetPassword"


#pragma mark --
#pragma mark - 第三方登录, 绑定

//第三方登录-校验绑定状态
#define URL_PASS_CHECKCONECT    @"/Passport/checkConnect"

//第三方登录-检查是否绑定第三方账号
#define URL_PASS_CHECKBIND      @"/Passport/checkBind"

//第三方登录-创建账号
#define URL_PASS_CREATE         @"/Passport/createConnect"

//第三方登录-注册账号
#define URL_PASS_REGISTER       @"/Passport/registerConnect"

//第三方登录-绑定账号
#define URL_PASS_BIND           @"/Passport/bindConnect"

//
/************************************************************************/
#pragma mark --
#pragma mark - 个人中心
//个人中心-获取我的资料
#define URL_ACCOUNT_SHOW    @"/Account/show"

//个人中心-用户信息修改
#define URL_UPDATE_UINFO    @"/Account/modifyperson"

//获取上传头像token
#define URL_GEI_IMGTOKEN    @"/Account/get_token"

//用户反馈
#define URL_USERFEEDBACK    @"/Feedback/create"

//我的优惠券
#define URL_MY_COUPSONS     @"/Account/coupons"

//我的积分
#define URL_MY_POINTS       @"/Account/score"

/************************************************************************/
#pragma mark --
#pragma mark - 收货地址
//新增收货地址
#define URL_ADD_ADDR        @"/Address/add"

//修改收货地址
#define URL_UPDATE_ADDR     @"/Address/update"

//拿收货地址列表
#define URL_GET_ADDR_LIST   @"/Address/getList"

//删除收货地址
#define URL_DEL_ADDR        @"/Address/delete"

/************************************************************************/
#pragma mark --
#pragma mark - 身份证
//身份证-查询单个
#define URL_SELECT_IDCARD   @"/Idcard/item"
//身份证-更新
#define URL_ADD_IDCARD      @"/Idcard/update"
//身份证秘钥KEY
#define KEY_SECRET_IDCARD   @"E(LBaGt]IW"

/************************************************************************/
#pragma mark --
#pragma mark - 首页
//首页 促销信息
#define URL_INDEXINFO       @"/Promotiom/getIndexList"

#define URL_GET_AREAIMGS    @"/Promotiom/getTopicList"

#define URL_GET_TOPICTAGS   @"/Promotiom/getTopicTags"

/************************************************************************/
#pragma mark --
#pragma mark - 商品
//商品分类_单独
#define URL_PRO_CATE        @"/Product/getCategory"

//商品分类_全部
#define URL_PRO_ALLCATE     @"/Product/getAllCategory"

//商品列表
#define URL_PRO_LIST        @"/Product/getList"

//商品详情
#define URL_PRO_DETAIL      @"/Product/item"

//按首字母和分类,拿品牌list
#define URL_GET_BRAND       @"/Product/getBrandByFirstAndCategoryId"

//按分类,拿所有字母品牌list
#define URL_GET_ALLBRAND    @"/Product/getBrandByCategoryId"

//拿所有商家信息
#define URL_ALL_SELLER      @"/Product/getBusiness"

//商品-评价列表
#define URL_PRO_COM_LIST    @"/Product/getCommentList"

//热词搜索
#define URL_HOT_SEARCH      @"/Keywords/favourite"

/************************************************************************/
#pragma mark --
#pragma mark - 购物车
//购物车-总数统计
#define URL_CART_COUNT      @"/Cart/count"

//获取购物车列表
#define URL_CART_LIST       @"/Cart/getList"

//添加购物车
#define URL_CART_ADD        @"/Cart/add"

//修改购物车
#define URL_CART_UPDATE     @"/Cart/update"

//删除购物车
#define URL_CART_DEL        @"/Cart/delete"

//运费计算
#define URL_CART_FREIGHT    @"/Cart/freight"


/************************************************************************/
#pragma mark --
#pragma mark - 核价
//核价
#define URL_CHECKPRICE      @"/Product/checkPrice"


/************************************************************************/
#pragma mark --
#pragma mark - 订单
//确认订单
#define URL_ORDER_CHECKOUT  @"/Orders/confirm"

//创建订单
#define URL_ORDER_CREATE    @"/Orders/create"

//订单详情
#define URL_ORDER_DETAIL    @"/Orders/item"

//订单列表
#define URL_ORDER_LIST      @"/Orders/getList"

//使用积分
#define URL_ORDER_CREDIT    @"/Orders/checkCredit"

//使用优惠码
#define URL_ORDER_COUPCODE  @"/Orders/checkCouponCode"

//取消订单
#define URL_ORDER_CANCEL    @"/Orders/cancel"

/************************************************************************/
#pragma mark --
#pragma mark - 包裹
//包裹列表
#define URL_BAG_LIST        @"/Bag/getList"

//包裹详情
#define URL_BAG_DETAIL      @"/Bag/item"

//包裹签收
#define URL_BAG_SIGN        @"/Bag/sign"

/************************************************************************/

#pragma mark --
#pragma mark - 快递
//快递查询
#define URL_EXPRESS_QUERY   @"/Kuaidi/item"


/************************************************************************/
#pragma mark --
#pragma mark - 喜欢
//喜欢列表
#define URL_LIKE_LIST       @"/Like/getList"
//喜欢-创建
#define URL_LIKE_CREAT      @"/Like/create"
//喜欢-删除
#define URL_LIKE_DEL        @"/Like/remove"
//喜欢-查询
#define URL_LIKE_CHECK      @"/Like/check"


/************************************************************************/
#pragma mark --
#pragma mark - 我的评价
//评价 创建
#define URL_COMMENT_CREATE          @"/Comment/create"
//评价-列表-全部【包含有评价和没有评价】
#define URL_COMMENT_ALL_LIST        @"/Comment/getListProduct"
//评价-列表-已经评价
#define URL_COMMENT_ALREADY_LIST    @"/Comment/getList"
//评价-单个评价【包含带分页的回复信息】
#define URL_COMMENT_SINGLE          @"/Comment/item"
//评价-回复评价
#define URL_COMMENT_ANSWER          @"/Comment/reply"



/************************************************************************/
#pragma mark --
#pragma mark - 收银台
//查询支付流水
#define URL_GET_PAYMENT             @"/Cashier/getPayment"


/************************************************************************/
#pragma mark --
#pragma mark - 帮助中心
//帮助中心
#define URL_HELP_CENTER             @"/Article/item"



#endif



