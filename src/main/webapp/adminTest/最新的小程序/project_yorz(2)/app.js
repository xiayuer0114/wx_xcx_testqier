//app.js
const Config = require("./config.js")
const util = require("./utils/util.js")
const Tools = require("./utils/wxTools/index.js")



App({
  Tools: Tools, // 载入小程序工具库
  // 生命周期函数--监听小程序初始化 当小程序初始化完成时，会触发 onLaunch（全局只触发一次）
  onLaunch: function (options) {
    // 显示调试信息
    Tools.Debug.App.App_onLaunch(options)
    /**
     * options.query
       uid 用户分享的编号
       packetId 用户分享的红包编号
       id 用户分享的文章编号
       shareTicket 取到更多的转发信息
     * options.scene
      1001	发现栏小程序主入口，“最近使用”列表
      1005	顶部搜索框的搜索结果页
      1006	发现栏小程序主入口搜索框的搜索结果页
      1007	单人聊天会话中的小程序消息卡片
      1008	群聊会话中的小程序消息卡片
      1011	扫描二维码
      1012	长按图片识别二维码
      1013	手机相册选取二维码
      1014	小程序模版消息
      1017	前往体验版的入口页
      1019	微信钱包
      1020	公众号 profile 页相关小程序列表
      1022	聊天顶部置顶小程序入口
      1023	安卓系统桌面图标
      1024	小程序 profile 页
      1025	扫描一维码
      1026	附近小程序列表
      1027	顶部搜索框搜索结果页“使用过的小程序”列表
      1028	我的卡包
      1029	卡券详情页
      1030	自动化测试下打开小程序
      1031	长按图片识别一维码
      1032	手机相册选取一维码
      1034	微信支付完成页
      1035	公众号自定义菜单
      1036	App 分享消息卡片
      1037	小程序打开小程序
      1038	从另一个小程序返回
      1039	摇电视
      1042	添加好友搜索框的搜索结果页
      1043	公众号模板消息
      1044	带 shareTicket 的小程序消息卡片（详情)
      1045	朋友圈广告
      1046	朋友圈广告详情页
      1047	扫描小程序码
      1048	长按图片识别小程序码
      1049	手机相册选取小程序码
      1052	卡券的适用门店列表
      1053	搜一搜的结果页
      1054	顶部搜索框小程序快捷入口
      1056	音乐播放器菜单
      1057	钱包中的银行卡详情页
      1058	公众号文章
      1059	体验版小程序绑定邀请页
      1064	微信连Wi-Fi状态栏
      1067	公众号文章广告
      1068	附近小程序列表广告
      1069	移动应用
      1071	钱包中的银行卡列表页
      1072	二维码收款页面
      1073	客服消息列表下发的小程序消息卡片
      1074	公众号会话下发的小程序消息卡片
      1077	摇周边
      1078	连Wi-Fi成功页
      1079	微信游戏中心
      1081	客服消息下发的文字链
      1082	公众号会话下发的文字链
      1084	朋友圈广告原生页
      1089	微信聊天主界面下拉，“最近使用”栏
      1090	长按小程序右上角菜单唤出最近使用历史
      1091	公众号文章商品卡片
      1092	城市服务入口
      1095	小程序广告组件
      1096	聊天记录
      1097	微信支付签约页
      1099	页面内嵌插件
      1102	公众号 profile 页服务预览
      1103	发现栏小程序主入口，“我的小程序”列表
      1104	微信聊天主界面下拉，“我的小程序”栏
     */

    // 展示本地存储能力
    Tools.Storage.setData('logs', Date.now(), true)
    Tools.Debug.Logger.info("本地存储:", Tools.Storage.getData('logs', true))
    
    //wx.hideTabBar() // 隐藏Tabbar

    wx.setTabBarStyle({
      color: '#000000',
      selectedColor: '#FFCA03',
      backgroundColor: '#FFFFFF',
      borderStyle: 'black'
    })

  },
  // 生命周期函数--监听小程序显示  当小程序启动，或从后台进入前台显示，会触发
  onShow: (options) => {
    // 显示调试信息
    Tools.Debug.App.App_onShow(options)
  },
  // 生命周期函数--监听小程序隐藏  当小程序从前台进入后台，会触发onHide
  onHide:() => {
    console.log("小程序被切换到后台")
  },
  // 错误监听函数 当小程序发生脚本错误，或者 api 调用失败时，会触发onError并带上错误信息
  onError: (msg) => {
    console.log("脚本错误或调用API失败:", msg)
  },
  // 页面不存在监听函数  当小程序出现要打开的页面不存在的情况，会带上页面信息回调该函数
  onPageNotFound: (res) => {
    // 显示调试信息
    Tools.Debug.App.App_onPageNotFound(res);

    wx.redirectTo({
      url: 'pages/index/notFound'
    }) // 如果是 tabbar 页面，请使用 wx.switchTab
  },


  /**
   * 小程序初始化
   * 1. 必备接口授权
   * 2. 完成系统配置的加载设置
   * 3. 系统登录
   * 4. 回调
   */
  init: function (successCB) {
    const first_system_init = (next_step) => {
      if (!this.globalData.sysConfigLoaded) {
        Tools.API_wx.getSystemInfo(this.setSystemInfo) // 获取设备信息
        //this.loadCustomFont() // 载入自定义字体
        this._getServerConfig(next_step)  // 获取服务器配置

        // 没有载入广告则加载广告
        if (this.globalData.advertisement.length == 0) {
          this.getAdvertisement()
        }
      } else {
        next_step && next_step()
      }
    }
    const second_check_authorize = (next_step) => {
      if (!this.globalData.scope.isChecked) {
        this.hasScope(next_step) // 检测必要的权限,本应用必须获取userInfo和userLocation
      } else {
        next_step && next_step()
      }
    }
    const third_login_server = (next_step) => {
      if (!this.globalData.sysUserLogined) {
        this._login(next_step) // 登陆服务器
      } else {
        next_step && next_step()
      }
    }
    // 考虑Promise封装
    first_system_init(() => {
      second_check_authorize(() => {
        third_login_server(() => {
          if (successCB) {
            successCB()
          }
        })
      })
    })
  },

  old_init: function() {

    // 第一步: 
    if (!this.globalData.sysConfigLoaded) { // 系统配置没有载入成功
      Tools.API_wx.getSystemInfo(this.setSystemInfo) // 获取设备信息
      //this.loadCustomFont() // 载入自定义字体
      this._getServerConfig()  // 获取服务器配置
    }

    // 第二步:
    if (!this.globalData.sysUserLogined) {

      this._getUserInfo() // 获取用户资料
      this._getCurrentLocation() // 获取坐标
    }

    // 第三步
    ; (() => { // 重复检测是否载入系统配置文件
      if (!this.globalData.sysConfigLoaded) { // 未加载执行
        let timmer = null
        let counts = 0
        const checkConfigLoaded = () => {
          if (this.globalData.sysConfigLoaded || this.globalData.showServerError) {
            if (timmer) {
              clearInterval(timmer)
            }
            if (successCB) {
              successCB()
            }
            // 没有载入广告则加载广告
            if (this.globalData.advertisement.length == 0) {
              this.getAdvertisement()
            }

            if (!this.globalData.sysUserLogined) { // 用户没有成功登陆系统
              this._login() // 登陆服务器
            }
          }
          counts += 1
          Tools.Debug.Logger.info("检测配置文件加载次数:", counts)
        }
        timmer = setInterval(checkConfigLoaded, 300)
      } else {
        if (!this.globalData.sysUserLogined) { // 用户没有成功登陆系统
          this._login() // 登陆服务器
        }

        if (successCB) {
          successCB()
        }
      }
    })()
  },

  /**
   * 设置设备信息
   */
  setSystemInfo: function(info) {
    /*
      //console.groupCollapsed("成功获取到设备信息:")
      console.log("手机型号", info.model)
      console.log("手机品牌", info.brand)
      console.log("设备像素比", info.pixelRatio)
      console.log("屏幕宽度", info.screenWidth)
      console.log("屏幕高度", info.screenHeight)
      console.log("可使用窗口宽度", info.windowWidth)
      console.log("可使用窗口高度", info.windowHeight)
      console.log("状态栏的高度", info.statusBarHeight)
      console.log("微信设置的语言", info.language)
      console.log("微信版本号", info.version)
      console.log("操作系统版本", info.system)
      console.log("客户端平台", info.platform)
      console.log("用户字体大小设置", info.fontSizeSetting)
      console.log("客户端基础库版本", info.SDKVersion)
      //console.groupEnd()
    */

    this.globalData.systemInfo.SDKVersion = info.SDKVersion // 客户端基础库版本
    if (util.compareVersion(info.SDKVersion, '1.5.0') >= 0) {
      this.globalData.systemInfo.brand = info.brand // 手机品牌  1.5.0
    }
    this.globalData.systemInfo.model = info.model // 手机型号
    this.globalData.systemInfo.pixelRatio = info.pixelRatio // 设备像素比
    if (util.compareVersion(info.SDKVersion, '1.1.0') >= 0) {
      this.globalData.systemInfo.screenWidth = info.screenWidth // 屏幕宽度  1.1.0
      this.globalData.systemInfo.screenHeight = info.screenHeight // 屏幕高度  1.1.0
    }
    this.globalData.systemInfo.windowWidth = info.windowWidth // 可使用窗口宽度
    this.globalData.systemInfo.windowHeight = info.windowHeight // 可使用窗口高度
    if (util.compareVersion(info.SDKVersion, '1.9.0') >= 0) {
      this.globalData.systemInfo.statusBarHeight = info.statusBarHeight // 状态栏的高度  1.9.0
    }
    this.globalData.systemInfo.language = info.language // 微信设置的语言
    this.globalData.systemInfo.version = info.version // 微信版本号
    this.globalData.systemInfo.system = info.system // 操作系统版本
    this.globalData.systemInfo.platform = info.platform // 客户端平台
    this.globalData.systemInfo.fontSizeSetting = info.fontSizeSetting // 用户字体大小设置。以“我-设置-通用-字体大小”中的设置为准，单位：px  1.5.0
  },
  /**
   * 载入自定义字体
   */
  loadCustomFont: function() {
    wx.loadFontFace({
      family: 'customFont-Light',
      source: 'url("//at.alicdn.com/t/webfont_1got95fweyo.ttf")',
      success: function (res) {
        console.log('--------------> 载入ttf字体成功', res) //  loaded
      },
      fail: function (res) {
        console.log('--------------> 载入ttf字体失败', res.status) //  error
      },
      complete: function (res) {
        console.log(res.status);
      }
    });
    wx.loadFontFace({
      family: 'customFont-Light',
      source: 'url("//at.alicdn.com/t/webfont_1got95fweyo.svg#customFont-Light")',
      success: function (res) {
        console.log('--------------> 载入svg字体成功', res) //  loaded
      },
      fail: function (res) {
        console.log('--------------> 载入svg字体失败', res) //  error
      },
      complete: function (res) {
        console.log('--------------> 载入字体状态', res.status);
      }
    });
  },

  /**
   * 获取服务器配置并初始化全局变量
   */
  _getServerConfig: function (nextFun){
    let retry = 0 // 重试次数为0
    const getConfig_SuccessCB = (res) => {
      if (res.cityList) { // 开通城市
        this.globalData.openCitys.splice(0, this.globalData.openCitys.length) // 清空
        res.cityList.forEach((item, index, array)=> {
          this.globalData.openCitys.push({
            id: index,
            name: item,
            order: index,
          })
        })
        if (this.globalData.openCitys.length > 0) {
          this.globalData.currentCity = this.globalData.openCitys[0].name
        } else {
          this.globalData.currentCity = '重庆市'
        }
      }
      // this.globalData.shopTypes = res.labelList || [] // 店铺分类
      if (res.labelList) { // 店铺分类
        this.globalData.shopTypes.splice(1, this.globalData.shopTypes.length) // 清空

        res.labelList.forEach((item, index, array) => {
          this.globalData.shopTypes.push({
            id: index + 1,
            name: item,
            order: index + 1,
          })
        })
      }

      this.globalData.distances = res.data.juli || 0 // 距离
      this.globalData.firstUseBonus = res.data.firstUse || 0 // 首次奖励
      this.globalData.firstTaskVistor = res.data.newUser_merchantId || '' // 新用户初次访问商家
      this.globalData.homeBackground = res.data.url_tuijiankaPic || '' // 首页底部图片
      this.globalData.settingBanner = res.data.url_wodePic || ''// 用户页底部显示
      this.globalData.settingBackground = res.data.url_wodeBackground || '' // 用户页头像背景
      this.globalData.signInBackground = res.data.url_signInBackground || '' // 签到背景
      this.globalData.helpID = res.data.shuoMing || '' // 帮助中心编号
      this.globalData.activityUrl = res.data.activityUrl || '' // 活动地址 https://tiesh.liebianzhe.com/activities/daka/daka.jsp
      this.globalData.sysConfigLoaded = true  // 载入服务器配置文件成功
      this.globalData.ruleBackground = res.data.url_usageRule

      if (this.globalData.activityUrl == 'error') {
        this.globalData.activityUrl = ''
      }

      nextFun && nextFun()
    }
    const getConfig_failCB = (res) => {
      Tools.Debug.Logger.info("调用获取配置失败, 待延迟再次执行", res)
      if (retry < 3) {
        retry ++ // 重试次数累加
        setTimeout(() => {
          Tools.API_server.getConfig({}, getConfig_SuccessCB, getConfig_failCB) // 重新发起调用请求直到次数已满
        }, retry * 1000) // 每次推迟一秒钟
      } else {
        const message = "未能正确载入系统配置文件,小程序终止运行?"
        console.log(message, res)
        this.globalData.showServerError = true
        this.globalData.showServerMessage = message
      }
    }
    Tools.API_server.getConfig({}, getConfig_SuccessCB, getConfig_failCB)
  },

  /**
   * 获取用户实时坐标[带刷新1分钟一次]
   */
  _getCurrentLocation: function () {
    const success_wx = (latitude, longitude) => {
      Tools.Debug.Logger.info("经纬度获取成功:", latitude, longitude)
      const currentCoordinate = this.globalData.userInfo.coordinate

      if (currentCoordinate.latitude != latitude || currentCoordinate.longitude != longitude) {
        this.globalData.userInfo.coordinate = {
          longitude: longitude,
          latitude: latitude
        }
      }
    }
    const fail_wx = (res) => {
      Tools.Debug.Logger.info("经纬度获取失败:", res)
    }
    Tools.API_wx.currentLocation(success_wx, fail_wx) // 失败延迟3秒, 成功每60秒获取一次用户坐标
  },
  /**
   * 获取用户资料[带失败重试三次]
   */
  _getUserInfo: function () {
    const success_wx = (res) => {
      this.setUserInfo(res)
    }
    const fail_wx = (res) => {
      Tools.Debug.Logger.info("获取用户资料失败:", res)
    }

    Tools.API_wx.getUserInfo(success_wx, fail_wx) // 失败重试三次
  },

  /**
   * 获取广告列表
   */
  getAdvertisement: function () {
    const post_data = {
      cityName: this.globalData.currentCity
    }
    const success_server = (res) => {
      if (res.data) {
        const temp_data = []
        res.data.forEach((item, index, array) => {
          temp_data.push({
            id: item.pubId || '',
            photo: item.pic || '',
            type: item.url || ''
          })
        })
        this.globalData.advertisement = temp_data
      }
    }
    const fail_server = (errorMessage) => {
      Tools.Debug.Logger.info("载入广告错误:", errorMessage)
    }
    Tools.API_server.getAdvertisement(post_data, success_server, fail_server)

  },
  /**
   * 检测授权信息, 没有授权则进行授权操作
   */
  hasScope: function (nextFun) {
    const scopeList = [
      'scope.userInfo', // 用户信息
      'scope.userLocation', // 地理位置
      //'scope.address', // 通讯地址
      //'scope.invoiceTitle', // 发票抬头
      //'scope.werun', // 微信运动步数
      //'scope.record', // 录音功能
      //'scope.writePhotosAlbum', // 保存到相册
      //'scope.camera', // 摄像头
    ]
    /**
     * 授权地理位置成功调用
     */
    const success_scope_userLocation = (msg) => {
      if(msg) {
        console.log('授权地理位置信息:', msg)
      }
      this.globalData.scope.userLocation = true
      this._getCurrentLocation() // 获取坐标
    }
    /**
     * 授权用户信息成功调用
     */
    const success_scope_userInfo = (msg) => {
      if (msg) {
        console.log('授权用户信息成功', msg)
      }
      this.globalData.scope.userInfo = true
      this._getUserInfo() // 获取用户资料
    }
    const get_scope_success = (authSetting) => {
      if (authSetting['scope.userLocation']) {
        success_scope_userLocation()
      } else {
        this.globalData.scope.userLocation = false
        console.log('弹出授权窗——获取地理位置')
        Tools.API_wx.authorize('scope.userLocation', success_scope_userLocation)
      }
      /*
      if (authSetting['scope.userInfo']) {
        success_scope_userInfo()
      } else {
        this.globalData.scope.userInfo = false
        console.log('弹出授权窗——获取用户资料')
        Tools.API_wx.authorize('scope.userInfo', success_scope_userInfo)
      }
      */
      //  && this.globalData.scope.userInfo
      if (this.globalData.scope.userLocation) {
        this.globalData.scope.isChecked = true
        nextFun && nextFun()
      } else {
        this.globalData.scope.isChecked = false
        console.log('=======> 没有授权成功, 显示授权窗')
        wx.reLaunch({
          url: '/pages/index/authorize'
        })
      }
    }
    const get_scope_fail = (res) => {
      this.globalData.scope.isChecked = false
    }

    Tools.API_wx.getSetting(get_scope_success, get_scope_fail)

  },
  /**
   * 显示登陆失败信息
   */
  showLoginReminding: function() {
    wx.showModal({
      title: '功能受限',
      content: '您还没有登录系统,不能使用该功能',
      cancelText: '继续使用',
      confirmText: '立即登陆',
      success: (res) => {
        if (res.confirm) {
          this._login()
        } else if (res.cancel) {
          console.log('用户点击取消')
          wx.navigateBack({
            delta: 1
          })
        }
      }
    })
  },
  /**
   * 显示载入错误,带重试和返回功能
   */
  showLoadDataError: function (errorInfo) {
    wx.showModal({
      title: errorInfo.title,
      content: errorInfo.content,
      cancelText: '返回',
      confirmText: '重试',
      success:  (res) => {
        if (res.confirm) {
          console.log('用户点击重试')
          if (errorInfo.retry) {
            errorInfo.retry()
          }
        } else if (res.cancel) {
          console.log('用户点击返回')
          wx.navigateBack({
            delta: 1
          })
        }
      }
    })
  },
  /**
   * 转到历史页面
   */
  jumpHistory: function() {

  },
  /**
   * 直接跳转到指定的页面, 注意带上参数
   */
  jumpPage: function (url, newTarget = false) {
    const jumptoURL = url
    const success_wx = (paramA, paramB, paramC) => {
      console.log("页面跳转:", paramA, paramB, paramC)
    }
    const fail_wx = (res) => {
      if (res.errMsg == 'navigateTo:fail can not navigateTo a tabbar page') {
        wx.switchTab({
          url: jumptoURL
        })
      }
    }
    if (newTarget) {
      wx.reLaunch({
        url: jumptoURL,
        success: success_wx,
        fail: fail_wx
      })
    } else {
      wx.navigateTo({
        url: jumptoURL,
        success: success_wx,
        fail: fail_wx
      })
    }
  },
  /**
   * 设置微信公开的用户资料
   */
  setUserInfo: function (res) {
    if (res.userInfo) {
      // 可以将 res 发送给后台解码出 unionId
      this.globalData.userInfo.nickName = res.userInfo.nickName
      this.globalData.userInfo.avatarUrl = res.userInfo.avatarUrl
      this.globalData.userInfo.city = res.userInfo.city
      this.globalData.userInfo.gender = res.userInfo.gender
      this.globalData.userInfo.province = res.userInfo.province
      this.globalData.userInfo.country = res.userInfo.country || 'CN'
      this.globalData.userInfo.language = res.userInfo.language || 'zh_CN'
    }
    this.globalData.userInfo.rawData = res.rawData || ''
    this.globalData.userInfo.signature = res.signature || ''
    this.globalData.userInfo.encryptedData = res.encryptedData || ''
    this.globalData.userInfo.iv = res.iv || ''

    this.globalData.scope.userInfo = true
  },
  /**
   * 创建一个临时Token
   */
  createToken: function () {
    const user_token = {
      status: 300, // 状态
      uid: '', // 用户编号
      code: '', // 随机密匙
      token : '', // 用户Token
    }
    const randCode = util.randomString(12)

    if (this.globalData.sysUserLogined) {
      user_token.status = 200
      user_token.uid = this.globalData.userInfo.server_uid
      user_token.code = randCode
      user_token.token = util.md5(this.globalData.userInfo.server_key + randCode)
    }
    // console.log("MD5加密:", user_token)
    return user_token
  },
  /**
   * 新用户任务流程
   */
  taskFirstUsed: function (nextFun) {
    if (this.globalData.userInfo.isNewUser) {
      switch (this.globalData.userInfo.taskTotal) {
        case 0:
          this.jumpPage('/pages/index/home?tabbarIndex=0', true)
        break
        case 1:
          this.jumpPage('/pages/aboutme/wallet', true)
        break
        case 2:
          this.jumpPage('/pages/index/home?tabbarIndex=1', true)
        break
        case 3:
          if (this.globalData.firstTaskVistor != '') {
            this.jumpPage('/pages/mylive/detail?id=' + this.globalData.firstTaskVistor)
          }
        break
        case 4:
          if (this.globalData.firstTaskVistor != '') {
            this.jumpPage('/pages/mylive/detail?id=' + this.globalData.firstTaskVistor)
          }
        break
        case 5:
          this.globalData.userInfo.isNewUser = false
          this.globalData.userInfo.taskTotal = -1
          this.jumpHistory()
        break
        default:
          console.log("新用户任务:", this.globalData.userInfo.taskTotal)
          this.jumpPage('/pages/index/home?tabbarIndex=0', true)
        break
      }
    } else {
      nextFun && nextFun()
    }
  },
  /**
   * 用户登陆
   * 1. 获取临时登录凭证
   * 2. 服务器登陆得到server_uid、server_key和是否是新用户
   */
  _login: function (nextFun) {
    /**
     * 服务端调用登陆成功
     */
    const success_server = (res) => {
      Tools.Debug.Logger.info("取到server登陆成功信息", res)
      if (res.userId){
        this.globalData.userInfo.server_uid = res.userId
        this.globalData.userInfo.server_key = res.key
        this.globalData.userInfo.city = res.user_city || this.globalData.openCitys[0].name

        if (res.isNewUser == 200) {
          this.globalData.userInfo.isNewUser = true
          this.globalData.userInfo.taskTotal = 0
        } else {
          this.globalData.userInfo.isNewUser = false
        }
        //this.globalData.userInfo.isNewUser = true
        //this.globalData.userInfo.taskTotal = 0

        this.globalData.sysUserLogined = true

        this.taskFirstUsed(nextFun)
      } else {
        Tools.Debug.Logger.info("服务器登陆失败，待重新走登陆流程")
      }
    }
    /**
     * 服务端调用登陆失败
     */
    const fail_server = (res) => {
      Tools.Debug.Logger.info("取到登陆信息失败", res)
      console.log("取到登陆信息失败", res)
      wx.showModal({
        title: '系统登录失败',
        content: '您没有成功登陆系统,部分功能将受限!',
        showCancel: false,
        confirmText: '我已知晓',
        success: function (res) {
          if (res.confirm) {
            console.log('用户点击确定')
          } else if (res.cancel) {
            console.log('用户点击取消')
          }
        }
      })
    }
    /**
     * 小程序成功获取临时登录凭证成功
     */
    const success_wx = (loginCode) => {
      const post_data = {
        longitude: this.globalData.userInfo.coordinate.longitude,
        latitude: this.globalData.userInfo.coordinate.latitude,
        code: loginCode,
        encryptedData: this.globalData.userInfo.encryptedData,
        iv: this.globalData.userInfo.iv,
      }
      Tools.Debug.Logger.info("请求服务器登陆:", post_data, )
      Tools.API_server.login(post_data, success_server, fail_server)
    }
    /**
     * 小程序成功获取临时登录凭证
     */
    const fail_wx = (res) => {
      Tools.Debug.Logger.info("获取临时登陆凭证失败", res)
    }

    Tools.API_wx.login(success_wx, fail_wx) // 失败重试三次
  },
  globalData: {
    canUse_CoverView: wx.canIUse('cover-view'), // 是否可使用cover-view组件
    canUse_OpenData: wx.canIUse('cover-view'),

    sysConfigLoaded: false, // 是否成功载入系统配置文件, 系统运行中持续为true
    sysUserLogined: false, // 用户是否成功登陆系统, 用户登陆后为true

    showServerError: false, // 显示服务器异常错误, 所有页面将禁止访问
    showServerMessage: '', // 显示的服务器错误信息

    scope: {
      isChecked: false,
      userInfo: false,
      userLocation: false,
    },

    serverUrl: Config.ServerHost, // 服务器路径,供API使用
    resourceLocal: Config.ResourceLocal, // 本地资源路径
    resourceServer: Config.ResourceServer, // 服务器资源路径

    // 当前设备信息
    systemInfo: {
      brand: '', //	手机品牌	1.5.0
      model: '', //	手机型号
      pixelRatio: '', //	设备像素比
      screenWidth: '', //	屏幕宽度	1.1.0
      screenHeight: '', //	屏幕高度	1.1.0
      windowWidth: '', //	可使用窗口宽度
      windowHeight: '', //	可使用窗口高度
      statusBarHeight: '', //	状态栏的高度	1.9.0
      language: '', //	微信设置的语言
      version: '', //	微信版本号
      system: '', //	操作系统版本
      platform: '', //	客户端平台
      fontSizeSetting: '', //	用户字体大小设置。以“我-设置-通用-字体大小”中的设置为准，单位：px	1.5.0
      SDKVersion: '', //	客户端基础库版本
    },
    userInfo: { // 用户资料
      /**
       * 我的账号: 5b60354d442138276583bc2e 5b6057c5d6c45916e28b041c
       * 测试账号: 5abd8d647d170b7c06047fdc
       *          5abe0d15d6c4590302ae1c55
       * 未知账号: 5b5198da5ff47d10e45aa442
       */
      server_uid: '', // 服务器的用户编号 
      server_key: '', // 服务器返回的用户key
      isNewUser: false, // 是否是新用户
      taskTotal: -1, // 新用户完成任务数量

      user_city: '', // 用户所在的城市
      coordinate: { // 用户当前坐标，已定时更新
        latitude: 29.56301, // 纬度[浮点数，范围为-90~90，负数表示南纬]
        longitude: 106.551557 // 经度[浮点数，范围为-180~180，负数表示西经]
      },

      // 普通登陆返回的数据
      nickName: '', // 	用户昵称
      avatarUrl: '', // 用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表132*132正方形头像）
      gender: '', // 用户的性别 1:男性 2:女性 0:未知
      city: '', // 用户所在城市
      province: '', // 用户所在省份
      country: '', // 用户所在国家
      language: '', // 用户的语言，简体中文为zh_CN
      // --withCredentials为真是返回的数据
      rawData: '', // 不包括敏感信息的原始数据字符串，用于计算签名
      signature: '', // 使用sha1(rawData+sessionkey)得到字符串，用于校验用户信息
      encryptedData: '', // 包括敏感数据在内的完整用户信息的加密数据
      iv: '', // 加密算法的初始向量

      openId: '', // encryptedData解密得到
      unionId: '', // encryptedData解密得到
      watermark: {
        appid: '', // encryptedData解密得到
        timestamp: 0 // encryptedData解密得到
      },


    },

    // 以下数据来自系统初始化配置
    distances: 0.0, // 距离,备用
    firstUseBonus: 0, // 首次奖励
    firstTaskVistor: '', // 新用户初次访问商家
    signInBackground: '', // 签到背景
    settingBackground: '', // 用户页头像背景
    settingBanner: '', // 用户页底部显示
    homeBackground: '', // 首页底部图片
    helpID: '', // 帮助中心编号
    ruleBackground: '', // 钱包使用规则背景
    activityUrl: '', // 活动中心地址 https://tiesh.liebianzhe.com/activities/daka/daka.jsp?userId=5b6057c5d6c45916e28b041c&token=16656add7110ae7dec671ede30ecd153&randCode=2DYYWHixts3N
    advertisement: [], // 详情页广告

    currentCity: "重庆市", // 当前城市编号,初始化时通过坐标自动判断,并存入本地
    openCitys: [ // 开通城市
      {
        id: 1,
        name: '重庆市',
        order: 1,
      },
    ],
    shopTypes: [ // 店铺分类
      {
        id: 0,
        name: '商圈',
        order: 0,
      }
    ],
  },
  
})
