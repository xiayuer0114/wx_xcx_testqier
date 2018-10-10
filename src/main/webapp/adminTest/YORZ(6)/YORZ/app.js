//app.js
App({
  onLaunch: function () {
    // // 展示本地存储能力
    // var logs = wx.getStorageSync('logs') || []
    // logs.unshift(Date.now())
    // wx.setStorageSync('logs', logs)
    // this.getLocation();

  },
  // 登录
  login: function (instance, method) {
    var that = this;
    wx.checkSession({
      success: function () {
        //session_key 未过期，并且在本生命周期一直有效
        var token = "";
        var userId = "";
        try {
          var value = wx.getStorageSync('token')
          if (value) {
            token = value;
          }
          var value = wx.getStorageSync('userId')
          if (value) {
            userId = value;
          }
        } catch (e) {
          // Do something when catch error
        }
        if (token == "" || userId == "") {
          that.authLogin(instance, method);
          return;
        }

        that.globalData.token = token;
        that.globalData.userId = userId;

        instance[method]();

      },
      fail: function () {
        that.authLogin(instance, method);
      }

    })

  },


  checkAuthorize: function () {
    // console.log("userInfo");
    // console.log(this.globalData.userInfo);
    //用户被禁用
    console.log(this.globalData.userInfo);
    if (this.globalData.userInfo == null) {
      return false;
    } else {
      return true;
    }
  },
  authLogin: function (instance, method) {
    // session_key 已经失效，需要重新执行登录流程
    var that = this;
    // 登录
    wx.login({
      success: res_data => {
        // 发送 res.code 到后台换取 openId, sessionKey, unionId
        var code = res_data.code;
        // console.log("code");
        // console.log(code);
        // 获取用户信息
        // 已经授权，可以直接调用 getUserInfo 获取头像昵称，不会弹框
        wx.showLoading({
          title: '加载中',
          mask: true
        })
        wx.request({
          url: 'https://tiesh.liebianzhe.com/applet/homeLogin.do',
          method: 'GET',
          data: {
            code: code,
          },
          header: {
            'content-type': 'application/json' // 默认值
          },
          success: function (res) {
            console.log("login...");
            console.log(res);
            if (res.statusCode == 200) {
              console.log("set sessionkey");

              that.globalData.token = res.data.key;
              that.globalData.userId = res.data.userId;
            }

            try {
              wx.setStorageSync('token', res.data.key);
              wx.setStorageSync('userId', res.data.userId);
            } catch (e) {

            }


            instance[method]();
          },
          complete: function () {
            wx.hideLoading();
          }
        })
      }
    })
  },
  /**
   * 检查用户是否禁用
   */
  checkAccountStatus: function () {
    if (this.globalData.is_disabled) {
      wx.showModal({
        title: '提示',
        content: '帐户被禁用，请联系管理员',
        showCancel: false,
        success: function (res) {
          if (res.confirm) {
            var pages = getCurrentPages();
            var current_page = pages[pages.length - 1];
            // console.log(current_page.route);
            if (current_page.route == "pages/index/index") {
              //nothing
            } else if (current_page.route == "pages/sentbiao/sentbiao" || current_page.route == "pages/my_home/my_home") {
              wx.switchTab({
                url: '/pages/index/index',
              })
            } else {
              wx.navigateBack({
              })
            }
          }
        }
      })
    }
    // console.log("status");
    return this.globalData.is_disabled;
  },
  /**
   * 收藏
   */
  collectArtcle: function (id) {
    var that = this;
    wx.request({
      url: this.globalData.host + 'applet/collectPub.do',
      method: 'GET',
      data: {
        userId: this.globalData.userId,
        pubId: id
      },
      success: function (res) {
        console.log(res);
        wx.showToast({
          title: res.data.message,
        })

      }
    })
  },
  /**
   * 根据id跳转到文章详情
   */
  jumpToDetail: function (id, mark) {
    var that = this;
    wx.navigateTo({
      url: '/pages/infor_detail/infor_detail?id=' + id + '&mark=' + mark,
    })
  },
  getLocation: function () {
    //获取地if()
    console.log('获取地理信息');
    var that = this
    wx.getLocation({
      type: 'wgs84',
      success: function (res) {
        console.log('坐标')
        console.log(res);
        var latitude = res.latitude;
        var longitude = res.longitude;
        that.globalData.jd = latitude;
        that.globalData.wd = longitude;

        var pages = getCurrentPages();
        var current_page = pages[pages.length - 1];
        var paga_url = current_page.route;
        if (paga_url == "pages/infor_detail/infor_detail") {
          current_page.onLoginCallBack();
        }
      },
      fail: function () {
        wx.openSetting({
          success: function (res) {
            console.log(res);
            if (res.authSetting['scope.userLocation']) {
              var pages = getCurrentPages();
              var current_page = pages[pages.length - 1];
              var paga_url = current_page.route;
              console.log(paga_url);
              if (paga_url == "pages/index/index") {
                wx.reLaunch({
                  url: '/pages/index/index',
                })
              } else if (paga_url == "pages/tetui/tetui") {
                wx.reLaunch({
                  url: '/pages/tetui/tetui',
                })
              } else if (paga_url == "pages/infor_detail/infor_detail") {
                current_page.onLoginCallBack();
              }
            }
          },
        })


      }
    })

  },
  globalData: {
    userInfo: null,
    host: "https://tiesh.liebianzhe.com/",
    // host: "http://192.168.1.104:8080/",
    token: '',
    userId: '',
    userName: '',
    avatar: '',
    mark: '5adad5cbd6c4593d38aa3787',
    jd: '',
    wd: '',
    artId: '',
    artMark: ''
  },
})