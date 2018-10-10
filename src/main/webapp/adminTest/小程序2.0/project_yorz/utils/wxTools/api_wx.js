const Debug = require("./debug.js")

// 微信调用
const wx_API = {
  runLocationTimmer: null,
  runTime: 0,
  toastTimmer: null, // 提示框超时时间
  /**
   * 获取设备信息
   */
  getSystemInfo: function(successCB){
    wx.getSystemInfo({
      success: (res) => {
        if (successCB) {
          successCB(res)
        }
      }
    })
  },
  /**
   * 授权请求
   */
  authorize: function (scopeItem, successCB){
      wx.authorize({
        scope: scopeItem,
        success: (errMsg) => {
          console.log('请求开启授权成功:', scopeItem, errMsg)
          if (successCB){
            successCB(errMsg)
          }
        },
        fail: (errMsg) => {
          console.log('请求开启授权失败:', scopeItem, errMsg)
        }
      })
  },
  /**
   * 获取用户信息
   */
  getUserInfo: function (successCB, failCB) {
    let retry = 0 // 重试次数为0
    const success_callback = (res) => {
      //console.log("获取用户信息成功:", res)
      if (successCB) {
        successCB(res)
      }

      // 由于 getUserInfo 是网络请求，可能会在 Page.onLoad 之后才返回
      // 所以此处加入 callback 以防止这种情况
      //if (this.userInfoReadyCallback) {
      //  this.userInfoReadyCallback(res)
      //}
    }
    const fail_callback = res => {
      //console.log("获取用户信息失败:", retry, res)
      if (retry < 3) {
        retry++ // 重试次数累加
        setTimeout(() => {
          wx.getUserInfo({
            withCredentials: true,
            success: success_callback,
            fail: fail_callback
          }) // 重新发起调用请求直到次数已满
        }, retry * 1000) // 每次推迟一秒钟
      } else {  // 重试3次仍然失败执行失败回调
        if (failCB) {
          failCB(res)
        }
      }
    }

    wx.getUserInfo({
      withCredentials: true,
      lang: 'zh_CN',
      timeout: 5000, // 5秒超时
      success: success_callback,
      fail: fail_callback
    })
  },
  /**
   * 用户登陆, 失败将自动重试3次
   */
  login: function (successCB, failCB) {
    let retry = 0 // 重试次数为0
    const success_callback = (res) => {
      if (res.code) {
        Debug.Logger.info("获取的临时登陆凭证", res)
        if (successCB) {
          successCB(res.code) // 处理服务端登陆流程,服务器后台换取openId,sessionKey,unionId
        } else {
          console.log("没有处理用户的登陆凭证[有效期五分钟]:", res.code)
        }
      } else {
        // 记录登陆失败
        console.log("没有获取到用户的登陆凭证:", res)
      }
    }
    const fail_callback = (res) => {
      Debug.Logger.info("获取临时登陆凭证重试：", retry, res)
      if (retry < 3) {
        retry++ // 重试次数累加
        setTimeout(() => {
          wx.login({
            success: success_callback,
            fail: fail_callback
          }) // 重新发起调用请求直到次数已满
        }, retry * 1000) // 每次推迟一秒钟
      } else {  // 重试3次仍然失败执行失败回调
        if (failCB){
          failCB(res)
        }
      }
    }
    wx.login({
      timeout: 6000,
      success: success_callback,
      fail: fail_callback
    })

  },
  /**
   * 获取用户的当前设置,只会出现小程序已经向用户请求过的权限
   * example:
        const cuccess_wx = (authSetting) => {
          if(authSetting) {
            if (authSetting['scope.userInfo']) {
              // 已经授权，可以直接调用getUserInfo获取头像昵称，不会弹框
              console.log("用户调用用户信息的权限")
            }
          }
        }
        getSetting(cuccess_wx)
   */
  getSetting: function (successCB, failCB){
    /**
     * 获取用户当前设置成功
     */
    const success_callback = (res) => {
      console.log("授权登陆返回结果:", res)
      /* 
        返回说明:
        res.authSetting = {
          "scope.userInfo": true,         // 用户信息
          "scope.userLocation": true,     // 地理位置
          "scope.address": true,          // 通讯地址
          "scope.invoiceTitle": true,     // 发票抬头
          "scope.werun": true,            // 微信运动步数
          "scope.record": true,           // 录音功能
          "scope.writePhotosAlbum": true, // 保存到相册
          "scope.camera": true            // 摄像头
        }
      */
      if (successCB) {
        successCB(res.authSetting)
      }
    }
    const fail_callback= (res) => {
      console.log("授权失败返回结果:", res)
      if (failCB){
        failCB(res)
      }
    }
    // 获取已有的授权
    wx.getSetting({
      success: success_callback,
      fail: fail_callback
    })

  },
  /**
   * 调起客户端小程序设置界面,仅出现已经向用户请求过的权限，返回用户设置的操作结果
   * 即将弃用,改用<button>组件来使用此功能
   */
  openSetting: function(successCB, failCB) {
    wx.openSetting({
      success: res => {
        console.log("《小程序设置》返回:", res)
        /* 返回说明
        res.authSetting = {
          "scope.userInfo": true,         // 用户信息
          "scope.userLocation": true,     // 地理位置
          "scope.address": true,          // 通讯地址
          "scope.invoiceTitle": true,     // 发票抬头
          "scope.werun": true,            // 微信运动步数
          "scope.record": true,           // 录音功能
          "scope.writePhotosAlbum": true, // 保存到相册
          "scope.camera": true            // 摄像头
        }
        */
        if (successCB){
          successCB(res.authSetting)
        }
      },
      fail: res => {
        console.log("《小程序设置》失败")
        if (failCB){
          failCB(res)
        }
      },
      complete: res => {

      }
    })
  },
  /**
   * 打开地图选择位置
   */
  chooseLocation: function (successCB, failCB){
    const success_callback = (res) => {
      let name = res.name // 位置名称
      let address = res.address // 详细地址
      let latitude = res.latitude // 纬度,使用gcj02国测局坐标系
      let longitude = res.longitude // 经度,使用gcj02国测局坐标系
      if (successCB){
        successCB(latitude, longitude)
      }
    }
    const fail_callback = (res) => {
      console.log("打开地图选择位置失败", res)
    }
    wx.chooseLocation({
      success: success_callback,
      fail: fail_callback
    })
  },
  /**
   * 获取用户当前的地理位置、速度。当用户离开小程序后,此接口无法调用
   * 当前获取成功仅返回经纬度
   */
  currentLocation: function(successCB, failCB) {
    const success_callback = (res) => {
      let latitude = res.latitude // 纬度，浮点数，范围为-90~90，负数表示南纬
      let longitude = res.longitude // 经度，浮点数，范围为-180~180，负数表示西经
      let speed = res.speed // 速度，浮点数，单位m/s
      let accuracy = res.accuracy // 位置的精确度
      let altitude = res.altitude // 高度，单位 m
      let verticalAccuracy = res.verticalAccuracy // 垂直精度，单位 m（Android 无法获取，返回 0）
      let horizontalAccuracy = res.horizontalAccuracy // 水平精度，单位 m

      if (successCB){
        successCB(latitude, longitude)
        if (this.runTime < new Date().getTime() - 60000){
          if (this.runLocationTimmer != null){
            clearTimeout(this.runLocationTimmer)
          }
          this.runTime = new Date().getTime()
          this.runLocationTimmer = setTimeout(() => {
            this.currentLocation(successCB, failCB)
          }, 60000) // 每60秒获取一次用户坐标
        }
      }
    }
    const fail_callback = (res) => {
      this.runLocationTimmer = setTimeout(() => {
        this.currentLocation(successCB, failCB)
      }, 3000) // 每3秒获取一次用户坐标
      if (failCB) {
        failCB(res)
      }
    }

    wx.getLocation({
      type: 'wgs84',
      success: success_callback,
      fail: fail_callback
    })
  },
  /**
   * 微信内置地图查看位置
   */
  openLocation: (latitude, longitude) => {
    wx.openLocation({
      latitude: latitude, // 纬度
      longitude: longitude, // 经度
      scale: 9, // 缩放比例,范围5~18
      name: '', // 位置名
      address: '', // 地址的详细说明
      success: () => { }, // 
      fail: () => { }, // 
      complete: () => {}, // 
    })
  },
  /**
   * 显示提示框,指定时间自动隐藏
   */
  showToast: function(title, timeout = 3000) {
    if (timeout || timeout < 3000) {
      timeout = 3000
    }
    if (this.toastTimmer){
      wx.hideToast()
      this.toastTimmer = null
    }
    wx.showToast({
      title: title,
      icon: 'none',
      mask: true,
      success: () => {
        this.toastTimmer = setTimeout(() => {
          wx.hideToast()
        }, timeout)
      }
    })
  }
}

wx_API.prototype = {
  show: function() {
    console.log(this.userInfo)
  }
}

module.exports = {
  API: wx_API
}
