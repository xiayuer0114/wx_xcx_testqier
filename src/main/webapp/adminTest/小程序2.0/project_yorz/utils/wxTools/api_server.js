const Config = require("../../config.js")
const Debug = require("./debug.js")

const URL_GetConfig = Config.ServerHost + 'appletV2/loadConfig.do' // 1.系统配置
const URL_UserLogin = Config.ServerHost + 'appletV2/homeLogin.do' // 2.用户登录
const URL_GetHomeCardInfo = Config.ServerHost + 'appletV2/loadTuiJianKa.do' // 3.首页推荐卡信息
const URL_Search = Config.ServerHost + 'appletV2/loadPubBySearch.do' // 4.用户搜索

const URL_GetMyliveBanner = Config.ServerHost + 'appletV2/loadShengHuoQuanBanner.do' // 5.生活圈Banner
const URL_GetMyliveArea = Config.ServerHost + 'appletV2/loadShangQuan.do' // 5.1商圈列表
const URL_GetMyLiveAreaShop = Config.ServerHost + 'appletV2/loadMerchantBySQ.do' //5.2 商圈店铺列表
const URL_GetMyliveShop = Config.ServerHost + 'appletV2/loadShengHuoQuan.do' // 5.3生活圈店铺列表

const URL_GetArticleDetail = Config.ServerHost + 'appletV2/getOnePubDetail.do' // 14.获取文章详情
const URL_FavoriteArticle = Config.ServerHost + 'appletV2/collectOnePub.do' // 15.添加收藏或取消收藏
const URL_ArticleAdvertisement = Config.ServerHost + 'appletV2/loadGuangGao.do' // 16. 加载广告

const URL_GetRecommend = Config.ServerHost + 'appletV2/loadZhuanTi.do' // 6.专题列表

const URL_GetMyWallet = Config.ServerHost + 'appletV2/loadMyWallet.do' // 7.获取我的钱包
const URL_GetTransactionRecord = Config.ServerHost + 'appletV2/loadJiaoYi.do' // 8加载交易明细
const URL_GetMyRedPacket = Config.ServerHost + 'appletV2/loadZhuanZeng.do' // 9.获取我的红包
const URL_GetMyFavorite = Config.ServerHost + 'appletV2/loadMyCollect.do' // 10.获取我的收藏
const URL_GetMyPurchaseHistory = Config.ServerHost + 'appletV2/loadMyPayHistory.do' // 11.获取我的消费记录
const URL_GetMySignInRecord = Config.ServerHost + 'appletV2/loadMySignInRecord.do' // 12.获取我的签到记录
const URL_SignIn = Config.ServerHost + 'appletV2/appletV2/signIn.do' // 13.提交签到



const Server_API = {
  /**
   * 获取系统配置
   */
  getConfig: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetConfig, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 用户登陆，后台调用wx_api, 换取 openid和session_key等
   */
  login: function (data, successCallback, failCallback, completeCallback) {
    //console.log('-----===> 登陆数据:', data)
    send(URL_UserLogin, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 用户搜索
   */
  search: function (data, successCallback, failCallback, completeCallback) {
    send(URL_Search, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取首页推荐卡信息
   */
  getHomeCardInfo: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetHomeCardInfo, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取文章详情
   */
  getArticleDetail: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetArticleDetail, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取广告
   */
  getAdvertisement: function (data, successCallback, failCallback, completeCallback) {
    send(URL_ArticleAdvertisement, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 收藏文章
   */
  postFavoriteArticle: function (data, successCallback, failCallback, completeCallback) {
    send(URL_FavoriteArticle, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取生活圈Banner
   */
  getMyliveBanner: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetMyliveBanner, data, successCallback, failCallback, completeCallback, false)
  },
  /**
   * 获取商圈列表
   */
  getMyliveArea: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetMyliveArea, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取商圈店铺列表
   */
  getMyliveAreaShop: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetMyLiveAreaShop, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取生活圈列表
   */
  getMyliveShop: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetMyliveShop, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取专题列表
   */
  getRecommend: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetRecommend, data, successCallback, failCallback, completeCallback)
  },


  /**
   * 获取我的钱包
   */
  getWallet: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetMyWallet, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取我的交易明细
   */
  getTransactionRecord: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetTransactionRecord, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取我的红包转赠
   */
  getRedPacket: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetMyRedPacket, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取我的收藏
   */
  getFavorite: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetMyFavorite, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取我的消费记录
   */
  getPurchaseHistory: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetMyPurchaseHistory, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 获取我的签到记录
   */
  getSignInRecord: function (data, successCallback, failCallback, completeCallback) {
    send(URL_GetMySignInRecord, data, successCallback, failCallback, completeCallback)
  },
  /**
   * 提交签到
   */
  postSignIn: function(data, successCallback, failCallback, completeCallback) {
    send(URL_SignIn, data, successCallback, failCallback, completeCallback)
  }
}


const send = function (url, data, successCallBack, failCallBack, completeCallBack, showLoading = true) {
  Debug.Logger.info(url + "  发起接口调用参数:", data)
  /**
   * API获取成功调用
   * 1. 初步解析结果
   */
  const success_cb = (res) => {
    //console.log("服务器API成功返回:", url, data, res)
    // 小程序接口返回结果判定
    if (res.statusCode == 200) {
      const serverData = res.data

      if (!serverData.hasOwnProperty('statusCode')) {
        Debug.Logger.info(url + " API接口异常  ", serverData)
        if (failCallBack) {
          failCallBack("API接口异常,请稍后再试")
        }
      } else {
        // 服务器返回的结果是否正确
        if (serverData.statusCode == 200) {
          Debug.Logger.info(url + " API返回成功  ", serverData.statusCode, serverData)
          if (successCallBack) {
            successCallBack(serverData) // 调用
          }
        } else { // 否则调用失败的信息
          Debug.Logger.info(url + " API返回失败  ", serverData.statusCode, serverData.message)
          if (failCallBack) {
            failCallBack(serverData.message)
          }
        }
      }

    } else {
      Debug.Logger.info(url + " API服务器异常  ", res.statusCode, res.header)
      if (failCallBack) {
        failCallBack("API服务器异常,请稍后再试")
      }
    }

  }
  /**
   * API获取失败调用
   */
  const fail_cb = (res) => {
    if (failCallBack) {
      failCallBack(res.message)
    }
  }
  /**
   * API获取结束调用
   */
  const complete_cb = (res) => {
    if (showLoading) {
      wx.hideNavigationBarLoading()
    }
    if (completeCallBack) {
      completeCallBack(res)
    }
  }
  if (showLoading) {
    wx.showNavigationBarLoading()
  }
  const requestTask = wx.request({
    url: url,
    data: data,
    header: {
      'content-type': 'application/x-www-form-urlencoded'
    },
    method: 'POST',
    dataType: 'json',
    responseType: 'text',
    success: success_cb,
    fail: fail_cb,
    complete: complete_cb
  })

  // requestTask.abort() // 取消请求任务
}

module.exports = {
  API: Server_API
}
