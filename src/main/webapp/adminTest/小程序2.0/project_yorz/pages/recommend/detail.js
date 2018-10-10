const WxParse = require('../../utils/wxParse/wxParse.js');

const app = getApp()
// pages/recommend/detail.js
Page({

  /**
   * 页面的初始数据
   */
  data: {
    resourceLocal: app.globalData.resourceLocal, // 本地资源路径
    resourceServer: app.globalData.resourceServer, // 服务器资源路径

    globalData: app.globalData,


    canShare: true, // 是否允许分享
    canCollect: false, // 是否可收藏
    haveCollect: false, // 是否已收藏

    article: { // 文章信息
      id: '',
      title: '',  // 文章标题
      subTitle: '',
      author: '', // 作者 [接口弃用]
      photography: '', // 摄影师 [接口弃用]
      collected: false, // 是否收藏
      images: [], // 图片
      video: {}, // 视频地址
      detail: [],
      tigs: [] // 标签
    }
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {

    console.log("是否传入参数:", options)
    if (!options) {
      options = {}
    }

    if (options.id){
      this.setData({
        'article.id': options.id
      })
    } else {
      // 提示参数不正确
    }

    app.init(() => {
      this.setData({
        globalData: app.globalData, // 全局数据
      })
      if (app.globalData.advertisement.length == 0) {
        app.getAdvertisement()
      }
      this._init()
    })
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function (options) {
  
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

    console.log("用户点击右上角分享", options)

    if (res.from === 'button') {
      console.log("来自页面内转发按钮", options.target)
    }

    return {
      title: this.data.article.title,
      path: '/pages/recommend/detail?id=' + this.data.article.id,
      imageUrl: this.data.resourceServer + this.data.article.images[0]
    }
  },

  tapBtnFavorite: function (e) {
    console.log("点击了收藏按钮")
    const post_data = {
      userId: this.data.globalData.userInfo.server_uid, // 用户编号
      pubId: this.data.article.id
    }
    const callback_success = (resData) => {
      console.log("添加收藏夹成功:", resData)
      if (resData.handing) {
        this.setData({
          'article.collected': !this.data.article.collected
        })
      }
    }
    const fail_callback = (resData) => {
      console.log("添加收藏夹失败:", resData)
    }
    app.Tools.API_server.postFavoriteArticle(post_data, callback_success, fail_callback)

  },
  tapBtnTags: function (e) {
    const typeid = e.currentTarget.dataset.id
    const typename = e.currentTarget.dataset.title
    console.log("即将跳转到:", typename)
    app.jumpPage('/pages/recommend/list?id=' + typeid + '&name=' + typename)
    /*
    wx.reLaunch({
      url: '/pages/recommend/index?type=' + typename,
      success: (res) => {
        console.log("跳转成功:", res)
      },
      fail: (res) => {
        console.log("跳转失败:", res)
      }
    })
    */
  },
  _init: function() {

    this._getArticleDetail()
  },
  _getArticleDetail: function() {

    const req_data = {
      pubId: this.data.article.id, // 文章编号
      userId: app.globalData.userInfo.server_uid, // 用户编号
      longitude: app.globalData.userInfo.coordinate.longitude, // 用户的经度
      latitude: app.globalData.userInfo.coordinate.latitude // 用户的纬度
    }
    const callback_success = (resData) => {
      if (resData) {

        //console.groupCollapsed("文章解析:")
        //console.log('原始文章内容:', resData.data.pubContent)
        // 解析HTML
        WxParse.wxParse('article.detail', 'html', resData.data.pubContent, this, 5);
        //console.groupEnd()

        this.setData({
          'article.id': resData.data.pubId || '',
          'article.title': resData.data.pubTitle || '',
          'article.subTitle': resData.data.pubSubhead || '',
          'article.video.source': resData.data.video || '',
          'article.collected': resData.data.beCollected == 1 ? true : false,
        })

        let temp_labels = []
        if (resData.data.labelList) {
          resData.data.labelList.forEach((item, index, array) => {
            console.log('Label:', item)
            temp_labels.push({
              id: index,
              title: item,
              type: ''
            })
          })
        }
        this.setData({
          'article.tigs': temp_labels
        })
      }
    }
    const fail_callback = errorMessage => {

      console.log("获取文章详情错误:", errorMessage)
      app.showLoadDataError({
        title: '数据获取失败',
        content: '文章详情载入失败:' + errorMessage,
        retry: () => {
          this._getArticleDetail()
        }
      })
    }
    const complete_callback = (resData) => {
      wx.hideLoading()
    }

    wx.showLoading({ // 显示加载框
      title: '内容呈现中...',
      mask: true,
      success: () => { },
      fail: () => { },
      complete: () => { }
    })
    app.Tools.API_server.getArticleDetail(req_data, callback_success, fail_callback, complete_callback)
  },

})