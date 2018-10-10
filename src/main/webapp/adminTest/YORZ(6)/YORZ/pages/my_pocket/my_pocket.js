// pages/my_pocket/my_pocket.js
var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    //分页数量
    pageSize:6,
    // 产品列表
    product_list:[],
    // 余额
    balance:0,
    // 图片主域名
    imgUrl:'',
    flag: true,
    motto: 'Hello World',
    userInfo: {},
    hasUserInfo: false,
    canIUse: wx.canIUse('button.open-type.getUserInfo'),

    systemInfo: {},
    location: {},
  },


  onLoad: function () {
    // 查看是否授权
    wx.getSetting({
      success: function (res) {
        if (res.authSetting['scope.userInfo']) {
          // 已经授权，可以直接调用 getUserInfo 获取头像昵称
          wx.getUserInfo({
            success: function (res) {
              console.log(res.userInfo)
            }
          })
        }
      }
    })
  },
  bindGetUserInfo: function (e) {
    console.log(e.detail.userInfo)
    console.log(e.detail.encryptedData)
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.setData({
      imgUrl:app.globalData.host
    })
    this.initDataPage(this.data.pageSize);
    this.setData({ flag: false });
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
  initDataPage: function (pageSize){
    this.getMyPocket(pageSize);
  },
  /**
   * 我的信息
   */
  getMyPocket: function (pageSize){
    var that = this ;
    wx.request({
      url: app.globalData.host +'applet/laodMy.do',
      method: 'POST',
      header: {
        'content-type': 'application/x-www-form-urlencoded'
      },
      data:{
        page:1,
        pageSize: pageSize,
        userId: app.globalData.userId
      },
      success:function(res){
        console.log(res);
        if(res.data.statusCode==200){
          that.setData({
            product_list:res.data.data,
            balance: res.data.balance,
          })
        } else if (res.data.statusCode == 301){
          app.authLogin(that,"onLoginCallBack");
        }
      }
    })
  },
  /**
 * 跳转详情
 */
  toDetailPage: function (e) {
    var id = e.currentTarget.dataset.id;
    var mark = e.currentTarget.dataset.mark;
    wx.navigateTo({
      url: '/pages/infor_detail/infor_detail?id=' + id + '&mark=' + mark,
    })
  },
  /**
   * 下拉刷新
   */
  bindDownLoad:function(){
    var that = this;
    var pageSize = that.data.pageSize;
    pageSize+=5
    that.setData({
      pageSize: pageSize
    })
    that.getMyPocket(pageSize);
  },
  onLoginCallBack: function(){ 
    var that = this;
    that.getMyPocket(0);
  },
  hide: function () {

    this.setData({ flag: true })

  }
})