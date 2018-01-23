//
//  RequestHeader.h
//  OptimalLive
//
//  Created by Sunwanwan on 2017/8/31.
//  Copyright © 2017年 HN. All rights reserved.
//  请求头

#ifndef RequestHeader_h
#define RequestHeader_h

#define REQUEST @"http://118.126.111.250"//本地测试地址
//#define REQUEST @"http://yb.liveniao.com"  //外网测试地址

#pragma mark - 公共部分

#define UploadToken      @"/account/getUploadToken"  // 上传token
#define SendSMS          @"/index/sendSms"           // 发送验证码
#define CheckVersion     @"/index/checkVersion"      // 检查版本信息
#define H5Page           @"/h5/index/page"           // H5界面
#define GetQcloudSign    @"/account/getUploadData"   // 腾讯云上传签名

#pragma mark ---------- 登录

#define RegisterFirst    @"/index/preRegister"       // 注册第一步
#define RegisterSeconed  @"/index/register"          // 注册第二步
#define Login            @"/index/login"             // 登录
#define AutoLogin        @"/index/autoLogin"         // 自动登录
#define ForgetPwd        @"/index/forgetPwd"         // 找回密码
#define Logout           @"/account/logout"          // 退出登录

#pragma mark ---------- 首页

#define Index            @"/account/index"             // 直播首页
#define FollowLive       @"/live/attentionLive"     // 关注的直播
#define Search           @"/account/search"         // 搜索
#define News             @"/article/newsList"         // 搜索

#pragma mark ----------  控制台
#define DeletePlayer       @"/account/delUserPlayer"         //删除列表
#define OrderPlayMode       @"/account/orderPlayMode"         //排序
#define HistoryModelList       @"/account/userHistoryMode"         //历史模式
#define SaveModel       @"/account/saveMode"         //保存模式
#define PlayList        @"/account/getPlayMode"         // 播放列表
#define ModelList        @"/account/getModeList"         // 系统模式列表
#define AddToPlayList        @"/account/addToPlay"
#define StartLive        @"/live/startLive"         // 开始直播
#define StopLive         @"/live/stopLive"          // 结束直播
#define AnchorHeartbeat  @"/live/anchorHeartbeat"   // 主播心跳 （暂时为免费心跳）
#define EnterRoom        @"/live/enterRoom"         // 进入直播间
#define PayRoomPrice     @"/live/payRoomPrice"      // 支付直播费用
#define GetUserCardInfo  @"/live/getUserInfo"       // 获取直播间用户的信息（用户卡片信息）
#define GiftList         @"/live/giftList"          // 直播间礼物列表
#define SendGift         @"/live/sendGift"          // 送礼
#define PraiseAnchor     @"/live/anchorLike"        // 点赞主播
#define LiveSendMsg      @"/live/sendMsg"           // 发消息/弹幕
#define GetOneGift       @"/live/getGift"           // 获取单个礼物
#define SetBannedSay     @"/live/setBannedSay"      // 用户禁言
#define SetFieldControl  @"/live/setFieldControl"   // 设置场控
#define ChangeLiveType   @"/live/changeLive"        // 切换直播模式

#pragma mark ----------  消息

#define ChatList             @"/msg/getChat"              // 消息列表
#define SystemMessageList    @"/msg/getSystemDetail"      // 系统消息列表
#define MessageDetail        @"/msg/getMsgDetail"         // 私聊消息详情
#define SendMessage          @"/msg/sendMsg"              // 发送聊天信息
#define QuitChat             @"/msg/quitMessageDetail"    // 退出对话详情
#define ClearUnread          @"/msg/clearUnread"          // 清除未读消息
#define RemoveChat           @"/msg/removeUserChat"       // 删除对话详情

#pragma mark ----------  我的
#define ConfigPwd          @"/account/setPwd"            // 设置密码
#define CheckPwd          @"/account/checkPwd"            // 检查是否设置过密码
#define UserInfo          @"/account/getAccount"            // 用户信息
#define SaveAccount       @"/account/saveAccount"           // 修改个人信息
#define MyFollow          @"/account/myFollow"              // 我的关注
#define ChangeFollow      @"/account/changeFollow"          // 关注/取消关注
#define MyFans            @"/account/myFans"                // 我的粉丝
#define MyEarning         @"/account/myIncome"              // 我的收益
#define BindAlipay        @"/account/bindThirdAccount"      // 绑定支付宝
#define CheckAlipay       @"/account/checkWithdrawAccount"  // 验证支付宝账户的正确性
#define CheckWithDraw     @"/account/checkWithdrawStatus"   // 检查提现状态
#define ApplyWithDrawal   @"/account/withdraw"              // 申请提现
#define CancelWithDrawal  @"/account/cancelWithdraw"        // 撤销提现
#define ExchangeList      @"/account/exchangeList"          // 兑换虚拟币列表
#define ExchangeDot       @"/account/exchangeDot"           // 兑换虚拟币
#define ExchangeDotLog    @"/log/exchangeLog"               // 兑换虚拟币记录
#define VIPList           @"/account/VipList"               // 我的VIP
#define BuyVIP            @"/account/buyVip"                // 购买VIP
#define FeedBack          @"/account/feedback"              // 意见反馈
#define ChangePhone       @"/account/changeMobile"          // 修改手机号
#define ChangePassword    @"/account/changePwd"             // 修改密码
#define LiveNotify        @"/account/setLiveNotify"         // 设置开播提醒
#define MyAccount         @"/account/myWallet"              // 我的账户
#define PrePay            @"/account/prePay"                // 充值
#define RechargeLog       @"/log/rechargeLog"               // 充值记录
#define WithdrawLog       @"/log/withdrawLog"               // 提现记录
#define ApplyAnchor       @"/account/anchorApply"           // 实名认证-主播申请
#define AuthStatus        @"/account/authStatus"            // 认证状态
#define GetGiftLog        @"/log/getGiftLog"                // 收礼记录
#define SendGiftLog       @"/log/sendGiftLog"               // 送礼记录
#define LiveIncomeLog     @"/log/liveIncomeLog"             // 开播收入记录
#define LivePayLog        @"/log/livePayLog"                // 看播消费记录
#define MyFieldControl    @"/account/myFieldControl"        // 我的场控
#define FansContribution  @"/account/userDotRankingList"    // 粉丝贡献榜
#define RankingListCoin   @"/account/rankingListCoin"       // 消费排行榜
#define RankingListDot    @"/account/rankingListDot"        // 收入排行榜


#endif /* RequestHeader_h */
