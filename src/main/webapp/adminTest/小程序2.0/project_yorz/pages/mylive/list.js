const app = getApp()

// pages/mylive/list.js
Page({
  liveList: null, // 组件对象
  /**
   * 页面的初始数据
   */
  data: {
    resourceServer: app.globalData.resourceServer, // 服务器资源路径
    resourceLocal: app.globalData.resourceLocal, // 本地资源路径
    globalData: app.globalData,

    currentType: '',
    currentArea: '',
    
    showPageMark: true, // 是否页面显示蒙版[防止误操作]
    
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    console.log("onLoad 是否传入参数:", options)
    if (!options) {
      options = {}
    }
    if (options.hasOwnProperty('type')){
      this.setData({
        currentType: options.type
      })
    }
    if (options.hasOwnProperty('area')) {
      this.setData({
        currentArea: options.area
      })
    }
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    this.liveList = this.selectComponent("#liveList")
    app.init(() => {
      this.setData({
        globalData: app.globalData, // 全局数据
      })
      console.log("Read: ", this.liveList, this.selectComponent("#liveList"))
      this._init()
    })
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function (options) {
    console.log("onShow 是否传入参数:", options)
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
    this.liveList.refresh()

    setTimeout(() => {
      wx.stopPullDownRefresh()
    }, 600)
  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {
    if (this.liveList) {
      if (!this.liveList.nextPage()) {
        // 已加载完所有数据
      }
    }
  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
    return this.liveList.shareInfo()
  },
  /**
   * 点击列表中的某项
   */
  handleTapListItem: function (e) {

  },
  handleTapBanner: function(e) {

  },
  handleLoadingBegin: function () {
    this.setData({
      'showPageMark': true
    })
  },
  handleLoadingOver: function () {
    this.setData({
      'showPageMark': false
    })
  },
  _init: function () {
    if (this.liveList) {
      this.liveList.init(app) // 调用组件初始化方法
    } else {
      console.log("没有列表", this.liveList)
    }
  },
})