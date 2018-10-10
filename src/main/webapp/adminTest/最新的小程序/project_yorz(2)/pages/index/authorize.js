const utils = require("../../utils/util.js")
const app = getApp()

// pages/index/authorize.js
Page({

  /**
   * 页面的初始数据
   */
  data: {
    debug: false,

    systemInfo: app.globalData.systemInfo,
    timmer: null,

    // 用户当前权限
    currentScope: {
      hasUserInfo: true, // <用户资料>授权,默认false, 通过查询改变
      hasUserLocation: false, // <地理位置>授权,默认false, 通过查询改变
      showAgreeLocation: false, // 调用<地理位置>授权后任未同意授权显示提醒
      openSettingType: 0, // 打开配置方式 0: 请升级 1:使用命令打开(1.1.0以上) 2:使用btn打开(2.0.7以上)
    }
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    // 1. 初始化设备信息
    this.setData({
      systemInfo: app.globalData.systemInfo,
    })

    if (this.data.debug) {
      console.group("使用功能:")
      console.log("设备信息:", this.data.systemInfo)

      console.log("使用getUserInfo", wx.canIUse('getUserInfo'))
      console.log("使用getLocation", wx.canIUse('getLocation'))
      console.log("使用OpenSetting", wx.canIUse('OpenSetting'))

      console.groupEnd()
    }
    // 2. 判断设备SDK版本
    if (utils.compareVersion(this.data.systemInfo.SDKVersion, '2.0.7') >= 0) {
      this.setData({
        'currentScope.openSettingType': 2
      })
      console.log("显示方式2:", this.data.currentScope.openSettingType)
    } else if (utils.compareVersion(this.data.systemInfo.SDKVersion, '1.1.0') >= 0) {
      this.setData({
        'currentScope.openSettingType': 1
      })
      console.log("显示方式1:", this.data.currentScope.openSettingType)
    }

    // 3. 查询用户是否同意获取地理位置和用户资料权限
    this.getUserAuthorize()
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
  
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
    console.log('onShow  ', this.data.currentScope)
    if(!this.data.timmer) {
      this.data.timmer = setInterval(this.handleHasScope, 500)
    }
  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
  
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
  
  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {
  
  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {
  
  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
  
  },


  handleHasScope: function () {
    console.log("检测是否有权限")
    // this.data.currentScope.hasUserInfo &&
    if (this.data.currentScope.hasUserLocation && !this.data.currentScope.showAgreeLocation) {
      clearInterval(this.data.timmer)
      this.data.timmer = null
      wx.reLaunch({
        url: '/pages/index/home'
      })
    }
  },
  _setUserAuthorize: function (authSetting) {

    if (authSetting['scope.userInfo']) {
      this.setData({
        'currentScope.hasUserInfo': true
      })
    } else {
      console.log("          需要同意获取<用户信息>授权")
      this.setData({
        'currentScope.hasUserInfo': false
      })
    }

    if (authSetting['scope.userLocation']) {
      this.setData({
        'currentScope.hasUserLocation': true,
        'currentScope.showAgreeLocation': false
      })
    } else {
      console.log("          需要同意获取用户<地理位置>授权")
      wx.authorize({
        scope: 'scope.userLocation',
        success: (errMsg) => {
          this.setData({
            'currentScope.hasUserLocation': true,
            'currentScope.showAgreeLocation': false
          })
          console.log("          授权获取<地理位置>成功", this.data.currentScope.hasUserLocation)
        },
        fail: (err) => {
          console.log("          授权获取<地理位置>失败", err)
          this.setData({
            'currentScope.showAgreeLocation': true // 显示引导开启地理位置
          })
        }
      })
    }

    if (this.data.currentScope.hasUserInfo && this.data.currentScope.hasUserLocation) {
      if (this.data.timmer) {
        clearInterval(this.data.timmer)
        this.data.timmer = null
      }
    }
  },

  /**
   * 查询用户是否同意了授权获取用户信息和地理位置权限
   */
  getUserAuthorize: function () {
    const success_wx = (authSetting) => {
      if (this.data.debug) {
        console.log("        查询拥有的权限：", authSetting)
      }
      this._setUserAuthorize(authSetting) // 设置授权结果
    }
    const fail_wx = (res) => {
      console.log("查询拥有的权限失败：", res)
      wx.showModal({
        title: '权限查询失败',
        content: '查询拥有的权限失败，是否重试？',
        success: (res) => {
          if (res.confirm) {
            console.log('用户点击确定')
            this.getUserAuthorize()

          } else if (res.cancel) {
            console.log('用户点击取消')
          }
        }
      })
    }
    app.Tools.API_wx.getSetting(success_wx, fail_wx)
  },

  /**
   * 获取<用户资料>
   */
  onGotUserInfo: function (e) {
    if (this.data.debug) {
      console.group("获取<用户资料>")
      console.log(e.type, e)
      console.log(e.detail.errMsg)
      console.log(e.detail.userInfo)
      console.log(e.detail.rawData)
      console.groupEnd()
    }
    if (e.detail.userInfo) {
      app.setUserInfo(e.detail)
      this.setData({
        'currentScope.hasUserInfo': true
      })
      wx.reLaunch({
        url: '/pages/index/home'
      })
    }
  },
  /**
   * 获取<设置页>
   */
  onGotOpenSetting: function(e) {
    if (this.data.debug) {
      console.log("            设置页结果:", e)
    }
    if(e.detail.authSetting){
      this._setUserAuthorize(e.detail.authSetting) // 设置授权结果
    }
  },
  /**
   * 打开设置页(已弃用,改为<button>组件打开)
   */
  onBtnOpenSetting: function (e) {
    const success_wx = authSetting => {
      console.log("打开《设置页》成功:", authSetting)
      this._setUserAuthorize(authSetting) // 设置授权结果
    }
    const fail_wx = res => {
      console.log("打开《设置页》失败:", res)
    }

    app.Tools.API_wx.openSetting(success_wx, fail_wx)
  },
  /**
   * 同意获取用户<地理位置>
   */
  onGotUserLocation: function (e) {
    wx.showLoading({
      title: '获取授权中',
      mask: true
    })

    this.setData({
      'currentScope.showAgreeLocation': false
    })
    wx.authorize({
      scope: 'scope.userLocation',
      success: (errMsg) => {
        console.log('已开启授权<地理位置>:', errMsg)
        wx.reLaunch({
          url: '/pages/index/home'
        })
      },
      fail: (errMsg) => {
        console.log('已开启授权<地理位置>失败:', errMsg)
      },
      complete: () => {
        setTimeout(() => {
          wx.hideLoading()
        }, 200)
      }
    })
  },

  onRefresh: function() {
    console.log("刷新应用: 直接跳转？")
    wx.reLaunch({
      url: '/pages/index/home'
    })
  },
})