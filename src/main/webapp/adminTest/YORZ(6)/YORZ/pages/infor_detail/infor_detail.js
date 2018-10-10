// pages/infor_detail/infor_detail.js
var app = getApp();
var WxParse = require('../../wxParse/wxParse.js');
Page({

  /**
   * 页面的初始数据
   */
  data: {
    //分享列表
    share_list: [
      {
        img: '../../images/share1.png',
        name: '微信好友'
      },
      {
        img: '../../images/share2.png',
        name: '朋友圈'
      },
      {
        img: '../../images/share3.png',
        name: 'QQ'
      },
      {
        img: '../../images/share4.png',
        name: 'QQ空间'
      },
      {
        img: '../../images/share5.png',
        name: '微博'
      },
      {
        img: '../../images/share6.png',
        name: 'instagram'
      },
      {
        img: '../../images/share7.png',
        name: 'facebook'
      },
      {
        img: '../../images/share8.png',
        name: 'twitter'
      }
    ],
    //是否显示分享
    to_share: false,
    //数据详情
    detail: {},
    //图片主域名
    imgUrl: app.globalData.host,
    //显示店家的数据
    isMerchant: true,
    // 经度
    jd: '',
    // 纬度
    wd: '',
    pub_name: '',
    pub_addr: '',
    ismark: true,
    is_collect: true,
    share_title: '',
    id: '',
    mark: '',
    show_detail: false,
    had_get: false
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
   
    if (app.globalData.jd == '') {
      app.getLocation();
    }
    if (app.globalData.userId == '') {
      app.login(this, "onLoginCallBack");

    }
    var id = options.id;

    var mark = options.mark;
    if (id != '') {
      app.globalData.artId = id
      this.setData({
        id: id,
      })
    }
    if (mark != '') {
      app.globalData.artMark = mark
      this.setData({
        mark: mark
      })
    }


    if (app.globalData.artMark != app.globalData.mark) {

      this.setData({
        ismark: false
      })
      this.initDataPage();
    } else {
      this.initDataPage();
    }

  },
  /**
   * 登录回调函数
   */
  onLoginCallBack: function () {
    var that = this;
    if (that.data.had_get==false){
      app.getLocation();
      that.getDetail(app.globalData.artId);
    }
    

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
    return {
      title: this.data.share_title,
      path: '/pages/infor_detail/infor_detail?id=' + this.data.id + '&mark=' + this.data.mark
    }
  },
  /**
   * 点击分享
   */
  toShareBtn: function () {
    this.setData({
      to_share: true
    })
  },
  /**
   * 点击蒙版消失
   */
  clickMask: function () {
    this.setData({
      to_share: false
    })
  },
  initDataPage: function () {

    this.getDetail(app.globalData.artId);
  },
  /**
   * 获取数据
   */
  getDetail: function (id) {
    var that = this;
    if (app.globalData.artMark != app.globalData.mark) {

      that.setData({
        ismark: false
      })

    }
    if (app.globalData.jd == '') {
      that.setData({
        show_detail: false
      })
    } else {
      that.setData({
        show_detail: true,
        had_get: true
      })
      wx.showLoading({
        title: '内容呈现中...',
      })
      wx.request({
        url: app.globalData.host + 'applet/getOnePubById.do',
        method: 'GET',
        data: {
          pubId: id,
          userId: app.globalData.userId,
          longitude: app.globalData.jd,
          latitude: app.globalData.wd
        },
        success: function (res) {
          console.log(res);
          if (res.data.statusCode == 200) {
            WxParse.wxParse('content', 'html', res.data.data.pubContent, that, 0);
            that.setData({
              detail: res.data.data,
              jd: res.data.data.latitude,
              wd: res.data.data.longitude,
              pub_name: res.data.data.name,
              pub_addr: res.data.data.addr,
              share_title: res.data.data.title,
              
            })
            if (res.data.data.beCollected == 0) {
              that.setData({
                is_collect: false
              })

            } else if (res.data.data.beCollected == 1) {
              that.setData({
                is_collect: true
              })

            }
            wx.hideLoading();
          }
        }
      })
    }


  },
  /**
   * 收藏文章
   */
  collectBtn: function (e) {
    var id = e.currentTarget.dataset.id
    app.collectArtcle(id);
    this.setData({
      is_collect: !this.data.is_collect
    })
  },
  /**
   * 拨打电话
   */
  makePhoneCall: function (e) {
    var num = e.currentTarget.dataset.num;
    wx.makePhoneCall({
      phoneNumber: num
    })
  },
  /**
   * 获取位置
   */
  getLocationBtn: function () {
    var that = this;
    wx.openLocation({
      latitude: that.data.jd,
      longitude: that.data.wd,
      name: that.data.pub_name,

      address: that.data.pub_addr
    })
  }
})