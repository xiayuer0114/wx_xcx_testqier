// pages/live_home/live_home.js
var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    // 详情列表
      detail:[],
      // 图片主域名
      imgUrl: app.globalData.host,
      page:1,
      // list1:[],
      // list2:[]
      show_poster: true,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var that = this;
    that.initDataPage(that.data.page);
    
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
  
  },
  /**
   * 初始化函数
   */
  initDataPage:function(page){
    this.getDetail(page);
   
  },
  
  /**
   * 图文视频
   */
  getDetail:function(page){
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/loadArticleAndVideo.do',
      method: 'GET',
      data: {
        page:page,
        pageSize:6,
        haveVideo:200
      },
      success: function (res) {
        //图文
        console.log("图文")
        console.log(res);
        if(res.statusCode==200){
          var list1 = that.data.detail;

          var list2 = res.data.data;

          list1 =list1.concat(list2);

          that.setData({
            detail:list1
          })
         console.log(that.data.detail);
        }
      }
    })
  },
  /**
   * 跳转详情
   */
  watchMore:function(e){
    var id = e.currentTarget.dataset.id;
    var mark = e.currentTarget.dataset.mark;
    app.jumpToDetail(id,mark);
  },
  /**
   * 上拉刷新
   */
  onReachBottom: function () {
    var that = this;
    var page = that.data.page;
    page += 1;
    that.setData({
      page: page
    })
    that.getDetail(page);
  },
  playBtn: function () {
    this.setData({
      show_poster: false
    })
  }
})