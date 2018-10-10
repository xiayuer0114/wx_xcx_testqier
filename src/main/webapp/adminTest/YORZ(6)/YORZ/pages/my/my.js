// pages/my/my.js
var app =getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    avatar:'',
    userName:''
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
  
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
   * 页面跳转
   */
  toMyCollet:function(e){
    var id = e.currentTarget.dataset.id;
    wx.navigateTo({
      url: '/pages/my_collect/my_collect?id='+id,
    })
  },
  toSignIn:function(e){
    var id = e.currentTarget.dataset.id;
    wx.navigateTo({
      url: '/pages/my_integral/my_integral?id='+id,
    })
  },
  toMyPocket:function(){
    wx.navigateTo({
      url: '/pages/my_pocket/my_pocket' ,
    })
  },
  /**
   * 获取头像和昵称
   */
  getUserDetail:function(){
    if(app.globalData.userId ==''){
      return
    }else{
      this.setData({
        avatar: app.globalData.avatar,
        userName: app.globalData.userName,
      })
    }
  }
})