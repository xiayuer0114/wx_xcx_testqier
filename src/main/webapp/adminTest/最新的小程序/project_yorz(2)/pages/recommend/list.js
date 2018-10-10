const app = getApp()

// pages/recommend/list.js
Page({
  articleList: null, // 组件对象
  /**
   * 页面的初始数据
   */
  data: {
    resourceLocal: app.globalData.resourceLocal, // 本地资源路径
    resourceServer: app.globalData.resourceServer, // 服务器资源路径

    globalData: app.globalData,
    app: app,
    loadMoreData: true,
    showPageMark: false,

    articleId: '',
    pageName: ''
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    console.log("监听页面加载 列表页传入参数:", options)
    if (!options) {
      options = {}
    }
    if (options && options.name) {
      this.setData({
        'articleId': options.id,
        'articleName': options.name,
      })
    }

  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    this.articleList = this.selectComponent("#articleList")
    app.init(() => {
      this.setData({
        globalData: app.globalData, // 全局数据
        app: app,
      })
      this._init()
    })
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function (options) {
    console.log("监听页面显示 列表页传入参数:", options)
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
    this.articleList.refresh()

    setTimeout(() => {
      wx.stopPullDownRefresh()
    }, 600)
  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {
    if (!this.articleList.nextPage()) {
      this.setData({
        loadMoreData: false, // 已加载完所有数据
      })
    }
  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
    return this.articleList.shareInfo()
  },
  /**
   * 组件响应事件 开始载入数据
   */
  handleLoadingBegin: function () {
    this.setData({
      'showPageMark': true
    })
  },
  /**
   * 组件响应事件 结束载入数据
   */
  handleLoadingOver: function () {
    this.setData({
      'showPageMark': false
    })
  },
  /**
   * 组件事件
   */
  handleTapType: function (e) {

  },
  /**
   * 组件事件
   */
  handleTapItem: function (e) {

  },
  /**
   * 页面初始化
   */
  _init: function () {
    this.articleList.init(app) // 调用组件初始化方法
  },

})